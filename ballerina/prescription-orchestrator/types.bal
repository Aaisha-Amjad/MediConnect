public type PrescriptionRequest record {|
    string patientId;
    string medication;
    string dosage;
    string? notes;
|};

public type WorkflowResult record {|
    string prescriptionId;
    string traceId;
    string workflowStatus;
    map<json> steps;
|};

public type AuditEntry record {|
    string traceId;
    string prescriptionId;
    string actorId;
    string action;
    string status;
    string timestamp;
    map<json> metadata;
|};