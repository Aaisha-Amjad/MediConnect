import ballerina/http;
import ballerina/log;

service /api/v1 on new http:Listener(8080) {

    resource function post prescriptions(
        http:Request req,
        @http:Header {name: "X-Actor-Id"} string? xActorId
    ) returns WorkflowResult|http:BadRequest|http:InternalServerError {

        json|error body = req.getJsonPayload();
        if body is error {
            return <http:BadRequest>{body: {message: "Invalid JSON body"}};
        }

        PrescriptionRequest|error prescReq = body.cloneWithType(PrescriptionRequest);
        if prescReq is error {
            return <http:BadRequest>{body: {message: "Required fields: patientId, medication, dosage"}};
        }

        string actorId = xActorId ?: "UNKNOWN";
        WorkflowResult|error result = runPrescriptionWorkflow(prescReq, actorId);

        if result is error {
            log:printError("Workflow failed", 'error = result);
            return <http:InternalServerError>{body: {message: result.message()}};
        }

        return result;
    }

    resource function get audit/[string traceId]() returns AuditEntry[]|http:NotFound {
        AuditEntry[] entries = getAuditByTraceId(traceId);
        if entries.length() == 0 {
            return <http:NotFound>{body: {message: "No audit records found for: " + traceId}};
        }
        return entries;
    }

    resource function get health() returns json {
        return {status: "healthy", service: "ballerina-orchestrator", version: "1.0.0"};
    }
}