import ballerina/http;
import ballerina/log;

listener http:Listener httpListener = new (8080);

service /api/v1 on httpListener {
    resource function get health() returns record {string status} {
        return {status: "healthy"};
    }

    resource function post prescriptions(
        http:Request request
    ) returns PrescriptionResponse|http:BadRequest|error {
        json payload = check request.getJsonPayload();
        string? actorId = request.getHeader("X-Actor-Id");

        if actorId is () {
            return http:BAD_REQUEST;
        }

        PrescriptionRequest prescriptionReq = check payload.cloneWithType();
        string traceId = generateTraceId();

        PrescriptionResponse response = check processPrescriptionWorkflow(
            prescriptionReq,
            actorId,
            traceId
        );

        return response;
    }

    resource function get audit/[string traceId]() returns AuditEntry|http:NotFound|error {
        AuditEntry? entry = getAuditEntry(traceId);

        if entry is () {
            return http:NOT_FOUND;
        }

        return entry;
    }
}
