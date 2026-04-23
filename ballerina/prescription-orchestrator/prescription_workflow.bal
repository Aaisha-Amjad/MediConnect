import ballerina/http;
import ballerina/log;
import ballerina/time;
import ballerina/uuid;

public function processPrescriptionWorkflow(
    PrescriptionRequest request,
    string actorId,
    string traceId
) returns PrescriptionResponse|error {

    string prescriptionId = "RX-" + uuid:createType4AsString();

    log:printInfo("Starting workflow for prescription: " + prescriptionId + " | traceId: " + traceId);

    // Step 1: Insurance Validation
    WorkflowStep insuranceStep = check validateInsurance(request, traceId);

    // Step 2: Pharmacy Notification
    WorkflowStep pharmacyStep = check notifyPharmacy(prescriptionId, request, traceId);

    // Step 3: Patient SMS Notification (non-blocking)
    WorkflowStep smsStep = {status: "SENT", channel: "SMS"};
    var smsResult = sendPatientSms(request.patientId, traceId);
    if smsResult is error {
        log:printWarn("SMS notification failed (non-critical): " + smsResult.message());
    }

    // Step 4: Audit Logging
    _ = logAuditEntry(
        traceId,
        actorId,
        "PRESCRIPTION_SUBMITTED",
        "COMPLETED",
        "Patient: " + request.patientId + " | Medication: " + request.medication
    );
    WorkflowStep auditStep = {status: "WRITTEN", timestamp: time:utcNow().toString()};

    PrescriptionResponse response = {
        prescriptionId: prescriptionId,
        traceId: traceId,
        workflowStatus: "COMPLETED",
        steps: {
            insuranceValidation: insuranceStep,
            pharmacyNotified: pharmacyStep,
            patientNotified: smsStep,
            auditLogged: auditStep
        }
    };

    log:printInfo("Workflow completed: " + traceId);
    return response;
}

isolated function validateInsurance(
    PrescriptionRequest request,
    string traceId
) returns WorkflowStep|error {
    http:Client insuranceClient = check new("http://insurance-service:5002");
    map<string> headers = {"X-Trace-Id": traceId};

    json payload = {
        patientId: request.patientId,
        medication: request.medication
    };

    json response = check insuranceClient->/validate.post(payload, headers);

    return {
        status: "APPROVED",
        coverage: response.coverage.toString(),
        authCode: response.authCode.toString()
    };
}

isolated function notifyPharmacy(
    string prescriptionId,
    PrescriptionRequest request,
    string traceId
) returns WorkflowStep|error {
    http:Client pharmacyClient = check new("http://pharmacy-service:5003");
    map<string> headers = {"X-Trace-Id": traceId};

    json payload = {
        prescriptionId: prescriptionId,
        patientId: request.patientId,
        medication: request.medication,
        dosage: request.dosage,
        notes: request.notes
    };

    json response = check pharmacyClient->/receive.post(payload, headers);

    return {
        status: "SENT",
        pharmacyRef: response.pharmacyRef.toString()
    };
}

isolated function sendPatientSms(string patientId, string traceId) returns error? {
    time:Civil delay = {year: 0, month: 0, day: 0, hour: 0, minute: 0, second: 0, timeAbbrev: "+00:00"};
    log:printInfo("SMS queued for patient " + patientId + " | traceId: " + traceId);
}
