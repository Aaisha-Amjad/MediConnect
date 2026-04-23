public type PrescriptionRequest record {
    string patientId;
    string medication;
    string dosage;
    string notes;
};

public type InsuranceResponse record {
    string status;
    string coverage;
    string authCode;
};

public type PharmacyResponse record {
    string status;
    string pharmacyRef;
};

public type SmsResponse record {
    string status;
    string channel;
};

public type AuditEntry record {
    string traceId;
    string actor;
    string timestamp;
    string action;
    string outcome;
    string details?;
};

public type WorkflowStep record {
    string status;
    string coverage?;
    string authCode?;
    string pharmacyRef?;
    string channel?;
    string timestamp?;
};

public type PrescriptionResponse record {
    string prescriptionId;
    string traceId;
    string workflowStatus;
    record {
        WorkflowStep insuranceValidation;
        WorkflowStep pharmacyNotified;
        WorkflowStep patientNotified;
        WorkflowStep auditLogged;
    } steps;
};
