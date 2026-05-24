
<div align="center">

# 🏥 MediConnect

### Smart Clinic API Gateway — WSO2 Enterprise Integration

*Secure, governed, and orchestrated healthcare API platform built on the full WSO2 stack*

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

MediConnect is a production-grade enterprise API gateway simulating a clinic ecosystem. It connects **Doctors**, **Patients**, and **Pharmacists** through a secured and governed platform — demonstrating real-world enterprise integration patterns using the complete WSO2 stack.

When a doctor submits a prescription, a Ballerina-orchestrated workflow automatically fires across multiple services:

```
Doctor (JWT: prescription:write)
    │
    ▼
WSO2 API Manager  ─── validates token scope + enforces throttle policy
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

| Layer | Technology | Purpose |
|---|---|---|
| Identity | WSO2 Identity Server 7.0 | OAuth2/OIDC, RBAC, scope management |
| Gateway | WSO2 API Manager 4.3 | API governance, throttling, developer portal |
| Orchestration | Ballerina Swan Lake | Prescription workflow + audit logging |
| Mock Services | Python Flask (×3) | Clinic, Insurance, Pharmacy backends |
| Infrastructure | Docker Compose | Full stack containerization |
| Testing | Postman | Automated API test collection |

---

## Architecture

```
┌─────────────────────────────────────────────┐
│         CLIENT  (Postman / React UI)        │
└──────────────────────┬──────────────────────┘
                       │ HTTPS
                       ▼
┌─────────────────────────────────────────────┐
│     WSO2 IDENTITY SERVER  :9443             │
│     OAuth2 · OIDC · RBAC · SSO             │
└──────────────────────┬──────────────────────┘
                       │ JWT Token
                       ▼
┌─────────────────────────────────────────────┐
│     WSO2 API MANAGER  :8243                 │
│     Gateway · Throttling · Dev Portal       │
│                                             │
│  AppointmentAPI · PrescriptionAPI · PharmacyAPI  │
└──────────────────────┬──────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────┐
│     BALLERINA ORCHESTRATOR  :8080           │
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
├── identity-server/
│   ├── deployment.toml          # OAuth2, CORS config
│   └── users.xml                # Pre-seeded users & roles
├── api-manager/
│   ├── apis/                    # OpenAPI 3.0 specs (×3)
│   └── throttle-policies/       # DoctorTier / PatientTier / PharmaTier
├── ballerina/
│   ├── main.bal                 # HTTP listener
│   ├── prescription_workflow.bal # Orchestration logic
│   ├── audit_logger.bal         # Immutable audit trail
│   └── types.bal                # Shared types
├── mock-services/
│   ├── clinic-service/app.py
│   ├── insurance-service/app.py
│   └── pharmacy-service/app.py
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
docker compose ps    # all containers should show "healthy"
```

| Service | URL | Login |
|---|---|---|
| WSO2 Identity Server | https://localhost:9443/console | admin / admin |
| WSO2 API Manager | https://localhost:9444/publisher | admin / admin |
| Developer Portal | https://localhost:9444/devportal | admin / admin |
| Ballerina | http://localhost:8080/health | — |

---

## Security Model

Three user roles, each with distinct OAuth2 scopes enforced at the API gateway:

| Role | Scopes | Throttle |
|---|---|---|
| Doctor | `appointment:read/write` `prescription:read/write` | 100 req/min |
| Patient | `appointment:read` `prescription:read` | 10 req/min |
| Pharmacist | `prescription:read/fill` | 50 req/min |

**Enforcement layers:** WSO2 IS issues scoped JWT → APIM validates signature + scope per endpoint → APIM enforces throttle tier → Ballerina logs actor for audit trail.

---

## API Reference

### Prescription API — `/prescription/v1`

| Method | Endpoint | Scope | Description |
|---|---|---|---|
| `POST` | `/prescriptions` | `prescription:write` | Submit prescription (triggers workflow) |
| `GET` | `/prescriptions/{id}` | `prescription:read` | Get prescription status |
| `GET` | `/audit/{traceId}` | `prescription:read` | Get full audit trail |

### Appointment API — `/appointment/v1`

| Method | Endpoint | Scope |
|---|---|---|
| `GET` | `/appointments` | `appointment:read` |
| `POST` | `/appointments` | `appointment:write` |

### Pharmacy API — `/pharmacy/v1`

| Method | Endpoint | Scope |
|---|---|---|
| `GET` | `/prescriptions/queue` | `prescription:fill` |
| `POST` | `/prescriptions/{id}/fill` | `prescription:fill` |

---

## Sample Workflow Response

```json
{
  "prescriptionId": "RX-20250115-0042",
  "traceId": "TRC-a1b2c3d4",
  "workflowStatus": "COMPLETED",
  "steps": {
    "insuranceValidation": { "status": "APPROVED", "coverage": "80%", "authCode": "INS-9982" },
    "pharmacyNotified":    { "status": "SENT", "pharmacyRef": "PHR-0042" },
    "patientNotified":     { "status": "SENT", "channel": "SMS" },
    "auditLogged":         { "status": "WRITTEN", "timestamp": "2025-01-15T10:30:00Z" }
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
