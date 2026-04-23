import ballerina/log;
import ballerina/time;

map<AuditEntry> auditStore = {};
int auditCounter = 0;

public function generateTraceId() returns string {
    auditCounter += 1;
    return "TRC-" + auditCounter.toString();
}

public function logAuditEntry(string traceId, string actor, string action, string outcome, string details = "") returns AuditEntry {
    time:Civil now = time:utcNow();
    string timestamp = now.toString();

    AuditEntry entry = {
        traceId: traceId,
        actor: actor,
        timestamp: timestamp,
        action: action,
        outcome: outcome,
        details: details
    };

    auditStore[traceId] = entry;
    log:printInfo("Audit logged: " + traceId + " | " + action + " | " + outcome);

    return entry;
}

public function getAuditEntry(string traceId) returns AuditEntry? {
    return auditStore[traceId];
}
