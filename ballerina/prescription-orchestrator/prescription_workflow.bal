import ballerina/http;
import ballerina/log;
import ballerina/time;
import ballerina/uuid;

configurable string insuranceUrl = "http://insurance-service:5002";
configurable string pharmacyUrl = "http://pharmacy-service:5003";

final http:Client insuranceClient = check new (insuranceUrl);
final http:Client pharmacyClient = check new (pharmacyUrl);

public function runPrescriptionWorkflow(
    PrescriptionRequest req,
    string actorId
) returns WorkflowResult|error {

    string traceId = "TRC-" + uuid:createType1AsString().substring(0, 8);
    string prescriptionId = "RX-" + uuid:createType1AsString().substring(0, 8).toUpperAscii();
    map<json> steps = {};

    log:printInfo("Workflow started", traceId = traceId, prescriptionId = prescriptionId);

    // Step 1: Insurance Validation
    json insurancePayload = {patientId: req.patientId, medication: req.medication, prescriptionId};
    json|http:ClientError insuranceResp = insuranceClient->post("/validate", insurancePayload);

    if insuranceResp is http:ClientError {
        return error("Insurance service unavailable. Please try again.");
    }

    boolean approved = check insuranceResp.approved;
    string? authCode = check insuranceResp.authCode;
    int coveragePct = check insuranceResp.coveragePercent;

    steps["insuranceValidation"] = {
        status: approved ? "APPROVED" : "REJECTED",
        coveragePercent: coveragePct,
        authCode: authCode ?: "N/A"
    };

    if !approved {
        string reason = check insuranceResp.reason;
        check writeAuditLog({
            traceId, prescriptionId, actorId,
            action: "SUBMIT_PRESCRIPTION", status: "REJECTED_BY_INSURANCE",
            timestamp: time:utcToString(time:utcNow()),
            metadata: {"reason": reason}
        });
        return {prescriptionId, traceId, workflowStatus: "REJECTED", steps};
    }

    // Step 2: Notify Pharmacy
    json pharmacyPayload = {
        prescriptionId, patientId: req.patientId,
        medication: req.medication, dosage: req.dosage,
        authCode: authCode, notes: req.notes ?: ""
    };

    json|http:ClientError pharmacyResp = pharmacyClient->post("/prescriptions", pharmacyPayload);

    if pharmacyResp is http:ClientError {
        pharmacyResp = pharmacyClient->post("/prescriptions", pharmacyPayload);
    }

    string pharmacyRef = pharmacyResp is http:ClientError ? "PENDING" :
                         (check pharmacyResp.pharmacyRef).toString();

    steps["pharmacyNotified"] = {
        status: pharmacyResp is http:ClientError ? "FAILED" : "SENT",
        pharmacyRef: pharmacyRef
    };

    // Step 3: Patient Notification
    json notifyPayload = {
        patientId: req.patientId,
        message: string `Your prescription for ${req.medication} is ready. Ref: ${pharmacyRef}`
    };

    json|http:ClientError notifyResp = pharmacyClient->post("/notify", notifyPayload);

    steps["patientNotified"] = {
        status: notifyResp is http:ClientError ? "FAILED" : "SENT",
        channel: "SMS"
    };

    // Step 4: Audit Log
    error? auditResult = writeAuditLog({
        traceId, prescriptionId, actorId,
        action: "SUBMIT_PRESCRIPTION", status: "COMPLETED",
        timestamp: time:utcToString(time:utcNow()),
        metadata: {"pharmacyRef": pharmacyRef, "medication": req.medication, "coverage": coveragePct}
    });

    steps["auditLogged"] = {
        status: auditResult is error ? "FAILED" : "WRITTEN",
        timestamp: time:utcToString(time:utcNow())
    };

    log:printInfo("Workflow completed", traceId = traceId);
    return {prescriptionId, traceId, workflowStatus: "COMPLETED", steps};
}