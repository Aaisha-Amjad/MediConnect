<div align="center">

# 🏥 MediConnect

### Smart Clinic API Gateway — WSO2 Enterprise Integration

_Secure, governed, and orchestrated healthcare API platform built on the full WSO2 stack_

<br/>

![WSO2 IS](https://img.shields.io/badge/WSO2_Identity_Server-7.0-FF7300?style=flat-square)
![WSO2 APIM](https://img.shields.io/badge/WSO2_API_Manager-4.3-FF7300?style=flat-square)
![Ballerina](https://img.shields.io/badge/Ballerina-Swan_Lake-20B6B0?style=flat-square)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?style=flat-square)
![Python](https://img.shields.io/badge/Python-Flask-3776AB?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-brightgreen?style=flat-square)

</div>

---

## Overview

MediConnect is a production-grade enterprise API gateway simulating a smart clinic ecosystem. It connects **Doctors**, **Patients**, and **Pharmacists** through a secured, governed, and orchestrated platform — demonstrating real-world enterprise integration patterns using the complete WSO2 stack.

When a doctor submits a prescription, a Ballerina-orchestrated workflow automatically fires across multiple services:

```
Doctor (JWT: prescription:write)
    │
    ▼
WSO2 API Manager ─── validates token scope + enforces throttle policy
    │
    ▼
Ballerina Orchestrator
    ├── Step 1 → Validate insurance coverage
    ├── Step 2 → Notify pharmacy
    ├── Step 3 → Send patient SMS confirmation
    └── Step 4 → Write immutable audit log
    │
    ▼
Response with full workflow traceId
```

---

## Tech Stack

| Layer          | Technology               | Purpose                                      |
| -------------- | ------------------------ | -------------------------------------------- |
| Identity       | WSO2 Identity Server 7.0 | OAuth2/OIDC, RBAC, scope management          |
| Gateway        | WSO2 API Manager 4.3     | API governance, throttling, developer portal |
| Orchestration  | Ballerina Swan Lake      | Prescription workflow + audit logging        |
| Mock Services  | Python Flask (×3)        | Clinic, Insurance, Pharmacy backends         |
| Infrastructure | Docker Compose           | Full stack containerization                  |
| Testing        | Postman                  | Automated API test collection                |

---

## Architecture

```
┌─────────────────────────────────────────────┐
│              CLIENT  (Postman)              │
└──────────────────────┬──────────────────────┘
                       │ HTTPS
                       ▼
┌─────────────────────────────────────────────┐
│       WSO2 IDENTITY SERVER  :9445           │
│        OAuth2 · OIDC · RBAC · SSO          │
└──────────────────────┬──────────────────────┘
                       │ JWT Token
                       ▼
┌─────────────────────────────────────────────┐
│     WSO2 API MANAGER  :9443 / :8243         │
│     Gateway · Throttling · Dev Portal       │
│                                             │
│  AppointmentAPI · PrescriptionAPI · PharmacyAPI  │
└──────────────────────┬──────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────┐
│      BALLERINA ORCHESTRATOR  :8080          │
└────────┬──────────────┬──────────────┬──────┘
         ▼              ▼              ▼
   Clinic Svc     Insurance Svc   Pharmacy Svc
     :5001           :5002           :5003
```

---

## Project Structure

```
mediconnect/
├── docker-compose.yml
├── security/
│   └── wso2carbon.jks
├── identity-server/
│   ├── deployment.toml
│   ├── users.example.xml
│   └── service-providers/
│       └── mediconnect-app.xml
├── api-manager/
│   ├── deployment.toml
│   └── apis/
│       ├── appointment-api.yaml
│       ├── prescription-api.yaml
│       └── pharmacy-api.yaml
├── ballerina/
│   ├── Dockerfile
│   └── prescription-orchestrator/
│       ├── Ballerina.toml
│       ├── types.bal
│       ├── audit_logger.bal
│       ├── prescription_workflow.bal
│       └── main.bal
├── mock-services/
│   ├── clinic-service/
│   │   ├── app.py
│   │   └── Dockerfile
│   ├── insurance-service/
│   │   ├── app.py
│   │   └── Dockerfile
│   └── pharmacy-service/
│       ├── app.py
│       └── Dockerfile
└── postman/
    └── MediConnect.postman_collection.json
```

---

## Quick Start

```bash
# 1. Pull WSO2 images (one-time, ~5 min)
docker pull wso2/wso2is:7.0.0
docker pull wso2/wso2am:4.3.0

# 2. Start the full stack
docker compose up -d

# 3. Wait ~5 min, then verify
docker compose ps
```

| Service                    | URL                                 | Login         |
| -------------------------- | ----------------------------------- | ------------- |
| WSO2 Identity Server       | https://localhost:9445/console      | admin / admin |
| WSO2 API Manager Publisher | https://localhost:9443/publisher    | admin / admin |
| WSO2 API Manager Admin     | https://localhost:9443/admin        | admin / admin |
| WSO2 Developer Portal      | https://localhost:9443/devportal    | admin / admin |
| Ballerina Orchestrator     | http://localhost:8080/api/v1/health | —             |
| Clinic Service             | http://localhost:5001/health        | —             |
| Insurance Service          | http://localhost:5002/health        | —             |
| Pharmacy Service           | http://localhost:5003/health        | —             |

---

## Security Model

| Role       | Scopes                                             | Throttle    |
| ---------- | -------------------------------------------------- | ----------- |
| Doctor     | `appointment:read/write` `prescription:read/write` | 100 req/min |
| Patient    | `appointment:read` `prescription:read`             | 10 req/min  |
| Pharmacist | `prescription:read/fill`                           | 50 req/min  |

**Enforcement layers:** WSO2 IS issues scoped JWT → APIM validates signature + scope per endpoint → APIM enforces throttle tier → Ballerina logs actor for audit trail.

---

## API Reference

### Prescription API

| Method | Endpoint              | Scope                | Description                             |
| ------ | --------------------- | -------------------- | --------------------------------------- |
| `POST` | `/prescriptions`      | `prescription:write` | Submit prescription (triggers workflow) |
| `GET`  | `/prescriptions/{id}` | `prescription:read`  | Get prescription status                 |
| `GET`  | `/audit/{traceId}`    | `prescription:read`  | Get full audit trail                    |

### Appointment API

| Method | Endpoint        | Scope               |
| ------ | --------------- | ------------------- |
| `GET`  | `/appointments` | `appointment:read`  |
| `POST` | `/appointments` | `appointment:write` |

### Pharmacy API

| Method | Endpoint                   | Scope               |
| ------ | -------------------------- | ------------------- |
| `GET`  | `/prescriptions/queue`     | `prescription:fill` |
| `POST` | `/prescriptions/{id}/fill` | `prescription:fill` |

---

## Sample Workflow Response

```json
{
  "prescriptionId": "RX-20250115-0042",
  "traceId": "TRC-a1b2c3d4",
  "workflowStatus": "COMPLETED",
  "steps": {
    "insuranceValidation": {
      "status": "APPROVED",
      "coverage": "80%",
      "authCode": "INS-9982"
    },
    "pharmacyNotified": { "status": "SENT", "pharmacyRef": "PHR-0042" },
    "patientNotified": { "status": "SENT", "channel": "SMS" },
    "auditLogged": { "status": "WRITTEN", "timestamp": "2025-01-15T10:30:00Z" }
  }
}
```

---

## Test Users

```
doctor1  / Doctor@123!   → Role: Doctor
patient1 / Patient@123!  → Role: Patient
pharma1  / Pharma@123!   → Role: Pharmacist
```

---

## License

MIT © 2025
