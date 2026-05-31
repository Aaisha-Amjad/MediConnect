import ballerina/io;

isolated AuditEntry[] auditLog = [];

public isolated function writeAuditLog(AuditEntry entry) returns error? {
    AuditEntry & readonly readonlyEntry = entry.cloneReadOnly();
    lock {
        auditLog.push(readonlyEntry);
    }
    string logLine = entry.toJsonString() + "\n";
    check io:fileWriteString("/tmp/mediconnect-audit.jsonl", logLine, io:APPEND);
}

public isolated function getAuditByTraceId(string traceId) returns AuditEntry[] {
    lock {
        return auditLog.filter(e => e.traceId == traceId).clone();
    }
}