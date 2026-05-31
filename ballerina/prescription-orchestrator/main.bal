import ballerina/http;
import ballerina/log;

service /api/v1 on new http:Listener(8080) {

    resource function post prescriptions(http:Caller caller, http:Request req) returns error? {
        json|error body = req.getJsonPayload();
        if body is error {
            check caller->respond(<http:Response> {statusCode: 400});
            return;
        }

        PrescriptionRequest|error prescReq = body.cloneWithType(PrescriptionRequest);
        if prescReq is error {
            check caller->respond(<http:Response> {statusCode: 400});
            return;
        }

        string actorId = req.getHeader("X-Actor-Id") ?: "UNKNOWN";
        WorkflowResult|error result = runPrescriptionWorkflow(prescReq, actorId);

        if result is error {
            log:printError("Workflow failed", 'error = result);
            check caller->respond(<http:Response> {statusCode: 500});
            return;
        }

        check caller->respond(result.toJson());
    }

    resource function get audit/[string traceId](http:Caller caller) returns error? {
        AuditEntry[] entries = getAuditByTraceId(traceId);
        if entries.length() == 0 {
            check caller->respond(<http:Response> {statusCode: 404});
            return;
        }
        check caller->respond(entries.toJson());
    }

    resource function get health(http:Caller caller) returns error? {
        check caller->respond({status: "healthy", service: "ballerina-orchestrator", version: "1.0.0"});
    }
}