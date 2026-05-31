import ballerina/io;
import ballerina/time;

isolated AuditEntry[] auditLog = [];

public isolated function writeAuditLog(AuditEntry entry) returns error? {
    lock {
        auditLog.push(entry);
    }
    string logLine = entry.toJsonString() + "\n";
    check io:fileWriteString("/tmp/mediconnect-audit.jsonl", logLine, io:APPEND);
}

public isolated function getAuditByTraceId(string traceId) returns AuditEntry[] {
    lock {
        return auditLog.filter(e => e.traceId == traceId).clone();
    }
}