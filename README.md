<div align="center">

<img src="https://img.shields.io/badge/WSO2-FF7300?style=for-the-badge&logo=wso2&logoColor=white" />
<img src="https://img.shields.io/badge/Ballerina-20B6B0?style=for-the-badge&logo=ballerina&logoColor=white" />
<img src="https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white" />
<img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white" />
<img src="https://img.shields.io/badge/OAuth2-EB5424?style=for-the-badge&logo=auth0&logoColor=white" />

<br/><br/>

```
███╗   ███╗███████╗██████╗ ██╗ ██████╗ ██████╗ ███╗   ██╗███╗   ██╗███████╗ ██████╗████████╗
████╗ ████║██╔════╝██╔══██╗██║██╔════╝██╔═══██╗████╗  ██║████╗  ██║██╔════╝██╔════╝╚══██╔══╝
██╔████╔██║█████╗  ██║  ██║██║██║     ██║   ██║██╔██╗ ██║██╔██╗ ██║█████╗  ██║        ██║   
██║╚██╔╝██║██╔══╝  ██║  ██║██║██║     ██║   ██║██║╚██╗██║██║╚██╗██║██╔══╝  ██║        ██║   
██║ ╚═╝ ██║███████╗██████╔╝██║╚██████╗╚██████╔╝██║ ╚████║██║ ╚████║███████╗╚██████╗   ██║   
╚═╝     ╚═╝╚══════╝╚═════╝ ╚═╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═╝   
```

### 🏥 Smart Clinic API Gateway — Enterprise Integration with WSO2 Full Stack

*A production-grade healthcare API platform demonstrating Identity, Governance & Orchestration*

<br/>

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![WSO2 IS](https://img.shields.io/badge/WSO2_IS-7.0-orange)
![WSO2 APIM](https://img.shields.io/badge/WSO2_APIM-4.3-orange)
![Ballerina](https://img.shields.io/badge/Ballerina-Swan_Lake-20B6B0)
![Status](https://img.shields.io/badge/Status-Production_Ready-brightgreen)

</div>

---

## 📖 Table of Contents

- [Overview](#-overview)
- [Architecture](#-architecture)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Quick Start](#-quick-start)
- [Phase-by-Phase Build Guide](#-phase-by-phase-build-guide)
  - [Phase 1 — Environment Setup](#phase-1--environment-setup)
  - [Phase 2 — WSO2 Identity Server](#phase-2--wso2-identity-server)
  - [Phase 3 — Mock Backend Services](#phase-3--mock-backend-services)
  - [Phase 4 — Ballerina Orchestration](#phase-4--ballerina-orchestration)
  - [Phase 5 — WSO2 API Manager](#phase-5--wso2-api-manager)
  - [Phase 6 — Postman Test Suite](#phase-6--postman-test-suite)
  - [Phase 7 — React Dashboard (Bonus)](#phase-7--react-dashboard-bonus)
- [API Reference](#-api-reference)
- [Security Model](#-security-model)
- [Demo Script](#-demo-script)
- [Troubleshooting](#-troubleshooting)

---

## 🌟 Overview

**MediConnect** is a fully functional enterprise API gateway built for a smart clinic ecosystem. It connects **Doctors**, **Patients**, and **Pharmacies** through a secured, governed, and fully orchestrated platform — using the complete WSO2 enterprise stack.

When a doctor submits a prescription, **Ballerina** automatically orchestrates a multi-step workflow:

```
Doctor submits prescription
        │
        ▼
  [WSO2 APIM] ── validates token scope (prescription:write)
        │         applies throttle policy (100 req/min for doctors)
        ▼
  [Ballerina] ── Step 1: Validate insurance coverage
        │         Step 2: Notify pharmacy
        │         Step 3: Send patient SMS confirmation
        │         Step 4: Write immutable audit log
        ▼
  Response with full workflow traceId
```

### What Makes This Project Exceptional

| Feature | Why It Stands Out |
|---|---|
| 🔐 **RBAC with JWT scopes** | 3 user roles, each with distinct OAuth2 scopes enforced at the gateway |
| 🔄 **Real workflow orchestration** | Ballerina chains 3+ services with error handling and compensation logic |
| 📋 **Immutable audit trail** | Every prescription has a traceable, timestamped, tamper-proof audit record |
| 🚦 **Live throttle enforcement** | Configurable per-role rate limits — demo-able with a live 429 response |
| 🏥 **Healthcare domain** | Realistic scenario that evaluators immediately understand |
| 🐳 **One-command startup** | Entire stack (`docker-compose up`) — shows DevOps maturity |
| 📬 **Postman automation** | Pre-request scripts auto-inject tokens — one-click demo flow |

---

## 🏗 Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    CLIENT LAYER                                  │
│          Postman Collection  |  React Dashboard (bonus)         │
└─────────────────────────┬───────────────────────────────────────┘
                          │  HTTPS
                          ▼
┌─────────────────────────────────────────────────────────────────┐
│              WSO2 IDENTITY SERVER  :9443                        │
│   OAuth2 / OIDC / RBAC / SSO / Scope Management                │
│                                                                 │
│   Users: doctor1 (Doctor) │ patient1 (Patient) │ pharma1       │
│   Scopes: appointment:read/write │ prescription:read/write/fill │
└─────────────────────────┬───────────────────────────────────────┘
                          │  JWT Token
                          ▼
┌─────────────────────────────────────────────────────────────────┐
│              WSO2 API MANAGER  :9444 / :8243                    │
│   Gateway │ Throttling │ Analytics │ Developer Portal           │
│                                                                 │
│   ┌──────────────┐  ┌──────────────────┐  ┌────────────────┐   │
│   │ AppointmentAPI│  │ PrescriptionAPI   │  │  PharmacyAPI   │   │
│   │ :8243/appt/v1│  │ :8243/presc/v1   │  │ :8243/pharm/v1 │   │
│   └──────┬───────┘  └────────┬─────────┘  └───────┬────────┘   │
└──────────┼──────────────────┼───────────────────-─┼────────────┘
           │                  │                      │
           ▼                  ▼                      ▼
┌─────────────────────────────────────────────────────────────────┐
│              BALLERINA ORCHESTRATION  :8080                     │
│              prescription_workflow.bal │ audit_logger.bal       │
└───────────┬──────────────────┬─────────────────────┬───────────┘
            │                  │                      │
            ▼                  ▼                      ▼
    ┌──────────────┐  ┌──────────────────┐  ┌────────────────────┐
    │ Clinic Svc   │  │ Insurance Svc    │  │ Pharmacy Svc       │
    │ :5001        │  │ :5002            │  │ :5003              │
    │ (Flask)      │  │ (Flask)          │  │ (Flask)            │
    └──────────────┘  └──────────────────┘  └────────────────────┘
```

---

## 🛠 Tech Stack

| Technology | Version | Purpose |
|---|---|---|
| WSO2 Identity Server | 7.0 | OAuth2, OIDC, RBAC, SSO, Scope Management |
| WSO2 API Manager | 4.3 | Gateway, throttling, developer portal, analytics |
| Ballerina | Swan Lake 2201.x | Prescription workflow orchestration |
| Python Flask | 3.x | 3 lightweight mock backend microservices |
| Docker & Compose | Latest | Full stack containerization |
| Postman | Latest | Automated API test collection |
| React + Vite | 18.x | Real-time workflow dashboard (bonus) |

---

## 📁 Project Structure

```
mediconnect/
├── 📄 docker-compose.yml              # Full stack: IS + APIM + services
├── 📄 README.md
│
├── 📂 identity-server/
│   ├── deployment.toml                # WSO2 IS config (OAuth2, CORS)
│   ├── users.xml                      # Pre-seeded: doctor1, patient1, pharma1
│   └── service-providers/
│       └── mediconnect-app.xml        # OIDC application config
│
├── 📂 api-manager/
│   ├── deployment.toml                # WSO2 APIM gateway config
│   ├── apis/
│   │   ├── appointment-api.yaml       # OpenAPI 3.0 spec
│   │   ├── prescription-api.yaml      # OpenAPI 3.0 spec
│   │   └── pharmacy-api.yaml          # OpenAPI 3.0 spec
│   └── throttle-policies/
│       ├── DoctorTier.xml             # 100 req/min
│       ├── PatientTier.xml            # 10 req/min
│       └── PharmaTier.xml             # 50 req/min
│
├── 📂 ballerina/
│   ├── Ballerina.toml
│   ├── main.bal                       # HTTP listener + routing
│   ├── prescription_workflow.bal      # Core orchestration logic
│   ├── audit_logger.bal               # Immutable audit trail
│   └── types.bal                      # Shared data types/records
│
├── 📂 mock-services/
│   ├── clinic-service/
│   │   ├── app.py                     # Appointments + patient records
│   │   └── Dockerfile
│   ├── insurance-service/
│   │   ├── app.py                     # Insurance validation mock
│   │   └── Dockerfile
│   └── pharmacy-service/
│       ├── app.py                     # Prescription queue + notifications
│       └── Dockerfile
│
├── 📂 postman/
│   ├── MediConnect.postman_collection.json
│   └── MediConnect.postman_environment.json
│
├── 📂 react-dashboard/               # Bonus UI
│   ├── src/
│   │   ├── App.jsx
│   │   ├── components/
│   │   │   ├── WorkflowTracker.jsx   # Live workflow step visualization
│   │   │   ├── AuditLog.jsx          # Real-time audit trail viewer
│   │   │   └── RateLimitMeter.jsx    # Shows APIM throttle headers
│   └── package.json
│
└── 📂 docs/
    ├── architecture-diagram.png
    └── demo-script.md
```

---

## ⚡ Quick Start

### Prerequisites

```bash
# Required
docker --version        # Docker 24+
docker compose version  # Compose v2
bal version             # Ballerina Swan Lake
python --version        # Python 3.11+
node --version          # Node 18+ (for React bonus)
```

### 1. Clone and Start

```bash
git clone https://github.com/yourusername/mediconnect.git
cd mediconnect

# Pull WSO2 images (one-time, takes ~5 min)
docker pull wso2/wso2is:7.0.0
docker pull wso2/wso2am:4.3.0

# Start the full stack
docker compose up -d

# Wait ~5 minutes for WSO2 to fully initialize
docker compose ps    # All containers should show "healthy"
```

### 2. Verify Services

| Service | URL | Credentials |
|---|---|---|
| WSO2 Identity Server | https://localhost:9443/console | admin / admin |
| WSO2 API Manager Publisher | https://localhost:9444/publisher | admin / admin |
| WSO2 Developer Portal | https://localhost:9444/devportal | admin / admin |
| Ballerina Orchestrator | http://localhost:8080 | — |
| Clinic Service | http://localhost:5001/health | — |
| Insurance Service | http://localhost:5002/health | — |
| Pharmacy Service | http://localhost:5003/health | — |

### 3. Get Your First Token

```bash
curl -k -X POST https://localhost:9443/oauth2/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=password" \
  -d "username=doctor1" \
  -d "password=Doctor@123" \
  -d "client_id=YOUR_CLIENT_ID" \
  -d "client_secret=YOUR_CLIENT_SECRET" \
  -d "scope=prescription:write appointment:write"
```

### 4. Submit a Prescription (triggers full Ballerina workflow)

```bash
curl -X POST https://localhost:8243/prescription/v1/prescriptions \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "patientId": "P001",
    "medication": "Amoxicillin 500mg",
    "dosage": "3x daily for 7 days",
    "notes": "Take with food"
  }'
```

**Expected response — full workflow trace:**
```json
{
  "prescriptionId": "RX-20250115-0042",
  "traceId": "TRC-a1b2c3d4",
  "workflowStatus": "COMPLETED",
  "steps": {
    "insuranceValidation": { "status": "APPROVED", "authCode": "INS-9982", "coverage": "80%" },
    "pharmacyNotified":    { "status": "SENT",     "pharmacyRef": "PHR-0042" },
    "patientNotified":     { "status": "SENT",     "channel": "SMS" },
    "auditLogged":         { "status": "WRITTEN",  "timestamp": "2025-01-15T10:30:00Z" }
  }
}
```

---

## 📋 Phase-by-Phase Build Guide

> **Timeline:** Phase 1–4 on Day 1, Phase 5–7 on Day 2.

---

### Phase 1 — Environment Setup
> ⏱ ~1.5 hours | Day 1 Morning

**Step 1.1 — Install prerequisites**

```bash
# Install Ballerina Swan Lake
# Download from: https://ballerina.io/downloads/
# Verify:
bal version

# Install Python deps (do this in each mock service folder later)
pip install flask flask-cors

# Verify Docker
docker compose version
```

**Step 1.2 — Scaffold the project**

```bash
mkdir mediconnect && cd mediconnect
mkdir -p identity-server/service-providers
mkdir -p api-manager/apis api-manager/throttle-policies
mkdir -p ballerina
mkdir -p mock-services/clinic-service
mkdir -p mock-services/insurance-service
mkdir -p mock-services/pharmacy-service
mkdir -p postman docs
touch docker-compose.yml README.md
```

**Step 1.3 — Write `docker-compose.yml`**

```yaml
version: '3.8'

services:
  wso2is:
    image: wso2/wso2is:7.0.0
    container_name: wso2is
    ports:
      - "9443:9443"
    healthcheck:
      test: ["CMD", "curl", "-k", "-f", "https://localhost:9443/api/health"]
      interval: 30s
      timeout: 10s
      retries: 10

  wso2apim:
    image: wso2/wso2am:4.3.0
    container_name: wso2apim
    ports:
      - "9444:9443"
      - "8243:8243"
      - "8280:8280"
    depends_on:
      wso2is:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "curl", "-k", "-f", "https://localhost:9443/api/health"]
      interval: 30s
      timeout: 10s
      retries: 15

  ballerina:
    build: ./ballerina
    container_name: ballerina-orchestrator
    ports:
      - "8080:8080"
    environment:
      - CLINIC_URL=http://clinic-service:5001
      - INSURANCE_URL=http://insurance-service:5002
      - PHARMACY_URL=http://pharmacy-service:5003
    depends_on:
      - clinic-service
      - insurance-service
      - pharmacy-service

  clinic-service:
    build: ./mock-services/clinic-service
    container_name: clinic-service
    ports:
      - "5001:5001"

  insurance-service:
    build: ./mock-services/insurance-service
    container_name: insurance-service
    ports:
      - "5002:5002"

  pharmacy-service:
    build: ./mock-services/pharmacy-service
    container_name: pharmacy-service
    ports:
      - "5003:5003"
```

**Step 1.4 — Start and verify**

```bash
docker compose up -d
# Wait 5 minutes, then:
docker compose ps         # All should show "healthy"
curl -k https://localhost:9443/console   # WSO2 IS should load
curl -k https://localhost:9444/publisher # WSO2 APIM should load
```

> ✅ **Checkpoint:** All 6 containers running and healthy.

---

### Phase 2 — WSO2 Identity Server
> ⏱ ~2 hours | Day 1 Morning

**Step 2.1 — Access the IS Console**

Open: `https://localhost:9443/console` → Login: `admin / admin`

**Step 2.2 — Create Roles**

Go to: **User Management → Roles → Add Role**

Create these 3 roles exactly:
```
Role Name: Doctor       Permissions: (none needed — scope-based)
Role Name: Patient      Permissions: (none needed)
Role Name: Pharmacist   Permissions: (none needed)
```

**Step 2.3 — Create Test Users**

Go to: **User Management → Users → Add User**

```
Username: doctor1   | Password: Doctor@123!  | Role: Doctor
Username: patient1  | Password: Patient@123! | Role: Patient
Username: pharma1   | Password: Pharma@123!  | Role: Pharmacist
```

**Step 2.4 — Register the OAuth2 Application**

Go to: **Applications → New Application → Standard-Based Application**

```
Application Name: MediConnect
Protocol:         OAuth2/OpenID Connect
Grant Types:      ✅ Password   ✅ Authorization Code   ✅ Refresh Token
Callback URLs:    https://oauth.pstmn.io/v1/callback
                  http://localhost:3000/callback
```

> 📋 **Copy the Client ID and Client Secret** — you'll need these for Postman and all token requests.

**Step 2.5 — Configure API Scopes**

Go to: **API Authorization → Scopes**

Create these 5 scopes:
```
appointment:read    → Description: View appointments
appointment:write   → Description: Book/cancel appointments
prescription:read   → Description: View prescriptions
prescription:write  → Description: Submit prescriptions (doctors only)
prescription:fill   → Description: Fill prescriptions (pharmacists only)
```

**Step 2.6 — Map Scopes to Roles**

Go to: **Applications → MediConnect → API Authorization → Authorize**

```
Doctor Role     → appointment:read, appointment:write, prescription:read, prescription:write
Patient Role    → appointment:read, prescription:read
Pharmacist Role → prescription:read, prescription:fill
```

**Step 2.7 — Test token generation**

```bash
# Get a doctor token
curl -k -X POST https://localhost:9443/oauth2/token \
  -d "grant_type=password&username=doctor1&password=Doctor@123!&scope=prescription:write" \
  -d "client_id=YOUR_CLIENT_ID&client_secret=YOUR_CLIENT_SECRET"

# Decode the JWT at jwt.io — verify scope claim includes prescription:write
```

> ✅ **Checkpoint:** Token contains correct role-based scopes.

---

### Phase 3 — Mock Backend Services
> ⏱ ~2 hours | Day 1 Afternoon

Create each mock service as a simple Python Flask app.

**Step 3.1 — Clinic Service** (`mock-services/clinic-service/app.py`)

```python
from flask import Flask, jsonify, request
from flask_cors import CORS
import uuid, datetime

app = Flask(__name__)
CORS(app)

appointments = {}
patients = {
    "P001": {"name": "Alice Johnson", "dob": "1990-05-14", "insuranceId": "INS-001"},
    "P002": {"name": "Bob Smith",     "dob": "1985-11-22", "insuranceId": "INS-002"},
}

@app.route('/health')
def health():
    return jsonify({"status": "healthy", "service": "clinic-service"})

@app.route('/appointments', methods=['GET'])
def list_appointments():
    return jsonify(list(appointments.values()))

@app.route('/appointments', methods=['POST'])
def book_appointment():
    data = request.json
    appt_id = f"APT-{str(uuid.uuid4())[:8].upper()}"
    appointment = {
        "id": appt_id,
        "patientId": data.get("patientId"),
        "doctorId": data.get("doctorId", "DR001"),
        "date": data.get("date"),
        "reason": data.get("reason"),
        "status": "BOOKED",
        "createdAt": datetime.datetime.utcnow().isoformat()
    }
    appointments[appt_id] = appointment
    return jsonify(appointment), 201

@app.route('/appointments/<appt_id>', methods=['GET'])
def get_appointment(appt_id):
    appt = appointments.get(appt_id)
    if not appt:
        return jsonify({"error": "Not found"}), 404
    return jsonify(appt)

@app.route('/patients/<patient_id>', methods=['GET'])
def get_patient(patient_id):
    patient = patients.get(patient_id)
    if not patient:
        return jsonify({"error": "Patient not found"}), 404
    return jsonify(patient)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)
```

**Step 3.2 — Insurance Service** (`mock-services/insurance-service/app.py`)

```python
from flask import Flask, jsonify, request
from flask_cors import CORS
import uuid, os

app = Flask(__name__)
CORS(app)

APPROVE_ALL = os.getenv("APPROVE_ALL", "true").lower() == "true"

@app.route('/health')
def health():
    return jsonify({"status": "healthy", "service": "insurance-service"})

@app.route('/validate', methods=['POST'])
def validate_insurance():
    data = request.json
    patient_id = data.get("patientId")
    medication  = data.get("medication")

    # Simulate: patient P999 always rejected (useful for demo)
    approved = APPROVE_ALL or patient_id != "P999"

    return jsonify({
        "patientId":       patient_id,
        "medication":      medication,
        "approved":        approved,
        "coveragePercent": 80 if approved else 0,
        "authCode":        f"INS-{str(uuid.uuid4())[:6].upper()}" if approved else None,
        "reason":          "Approved" if approved else "Patient not covered for this medication"
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5002)
```

**Step 3.3 — Pharmacy Service** (`mock-services/pharmacy-service/app.py`)

```python
from flask import Flask, jsonify, request
from flask_cors import CORS
import uuid, datetime

app = Flask(__name__)
CORS(app)

prescriptions = {}
notifications = []

@app.route('/health')
def health():
    return jsonify({"status": "healthy", "service": "pharmacy-service"})

@app.route('/prescriptions', methods=['POST'])
def receive_prescription():
    data = request.json
    presc_id = data.get("prescriptionId", f"PHR-{str(uuid.uuid4())[:6].upper()}")
    prescriptions[presc_id] = {
        **data,
        "pharmacyRef": presc_id,
        "status": "QUEUED",
        "receivedAt": datetime.datetime.utcnow().isoformat()
    }
    return jsonify({"pharmacyRef": presc_id, "status": "QUEUED"}), 201

@app.route('/prescriptions/<presc_id>', methods=['GET'])
def get_prescription(presc_id):
    p = prescriptions.get(presc_id)
    if not p:
        return jsonify({"error": "Not found"}), 404
    return jsonify(p)

@app.route('/prescriptions/<presc_id>/fill', methods=['POST'])
def fill_prescription(presc_id):
    if presc_id not in prescriptions:
        return jsonify({"error": "Not found"}), 404
    prescriptions[presc_id]["status"] = "DISPENSED"
    prescriptions[presc_id]["dispensedAt"] = datetime.datetime.utcnow().isoformat()
    return jsonify(prescriptions[presc_id])

@app.route('/notify', methods=['POST'])
def notify_patient():
    data = request.json
    notif = {
        "id": str(uuid.uuid4()),
        "patientId": data.get("patientId"),
        "message": data.get("message"),
        "channel": "SMS",
        "sentAt": datetime.datetime.utcnow().isoformat()
    }
    notifications.append(notif)
    return jsonify({"status": "SENT", "notificationId": notif["id"]})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5003)
```

**Step 3.4 — Dockerfiles for each service**

Create this `Dockerfile` in each mock service folder:
```dockerfile
FROM python:3.11-slim
WORKDIR /app
RUN pip install flask flask-cors
COPY app.py .
EXPOSE 5001
CMD ["python", "app.py"]
```
> Change `EXPOSE` to 5002 and 5003 for the other services.

> ✅ **Checkpoint:** `curl http://localhost:5001/health` returns `{"status":"healthy"}`

---

### Phase 4 — Ballerina Orchestration
> ⏱ ~3 hours | Day 1 Evening — *This is the star of the project*

**Step 4.1 — Initialize project**

```bash
cd ballerina
bal new prescription-orchestrator
cd prescription-orchestrator
```

**Step 4.2 — `types.bal`** — shared data records

```ballerina
public type PrescriptionRequest record {|
    string patientId;
    string medication;
    string dosage;
    string? notes;
|};

public type InsuranceResult record {|
    boolean approved;
    int coveragePercent;
    string? authCode;
    string reason;
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
    string actorRole;
    string action;
    string status;
    string timestamp;
    map<json> metadata;
|};
```

**Step 4.3 — `audit_logger.bal`** — immutable audit trail

```ballerina
import ballerina/file;
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
```

**Step 4.4 — `prescription_workflow.bal`** — the orchestration engine

```ballerina
import ballerina/http;
import ballerina/log;
import ballerina/time;
import ballerina/uuid;

configurable string clinicUrl    = "http://clinic-service:5001";
configurable string insuranceUrl = "http://insurance-service:5002";
configurable string pharmacyUrl  = "http://pharmacy-service:5003";

final http:Client insuranceClient = check new (insuranceUrl);
final http:Client pharmacyClient  = check new (pharmacyUrl);

public function runPrescriptionWorkflow(
    PrescriptionRequest req,
    string actorId
) returns WorkflowResult|error {

    string traceId       = "TRC-" + uuid:createType1AsString().substring(0, 8);
    string prescriptionId = "RX-" + time:utcNow()[0].toString() + "-" + uuid:createType1AsString().substring(0, 4).toUpperAscii();
    map<json> steps = {};

    log:printInfo("Workflow started", traceId = traceId, prescriptionId = prescriptionId);

    // ── Step 1: Insurance Validation ──────────────────────────────────────────
    json insurancePayload = {
        patientId:  req.patientId,
        medication: req.medication,
        prescriptionId
    };

    json|http:ClientError insuranceResponse = insuranceClient->post("/validate", insurancePayload);

    if insuranceResponse is http:ClientError {
        log:printError("Insurance service unreachable", traceId = traceId);
        return error("Insurance service unavailable. Please try again later.");
    }

    boolean approved        = check insuranceResponse.approved;
    string? authCode        = check insuranceResponse.authCode;
    int coveragePct         = check insuranceResponse.coveragePercent;

    steps["insuranceValidation"] = {
        status:          approved ? "APPROVED" : "REJECTED",
        coveragePercent: coveragePct,
        authCode:        authCode ?: "N/A"
    };

    if !approved {
        string reason = check insuranceResponse.reason;
        check writeAuditLog({
            traceId, prescriptionId, actorId,
            actorRole: "Doctor", action: "SUBMIT_PRESCRIPTION",
            status: "REJECTED_BY_INSURANCE",
            timestamp: time:utcToString(time:utcNow()),
            metadata: {"reason": reason}
        });
        return {
            prescriptionId, traceId,
            workflowStatus: "REJECTED",
            steps
        };
    }

    // ── Step 2: Notify Pharmacy ───────────────────────────────────────────────
    json pharmacyPayload = {
        prescriptionId,
        patientId:  req.patientId,
        medication: req.medication,
        dosage:     req.dosage,
        authCode:   authCode,
        notes:      req.notes ?: ""
    };

    json|http:ClientError pharmacyResponse = pharmacyClient->post("/prescriptions", pharmacyPayload);

    if pharmacyResponse is http:ClientError {
        // Retry once
        pharmacyResponse = pharmacyClient->post("/prescriptions", pharmacyPayload);
    }

    string pharmacyRef = pharmacyResponse is http:ClientError ? "PENDING" :
                         (check pharmacyResponse.pharmacyRef).toString();

    steps["pharmacyNotified"] = {
        status:      pharmacyResponse is http:ClientError ? "FAILED_RETRYING" : "SENT",
        pharmacyRef: pharmacyRef
    };

    // ── Step 3: Patient Notification ─────────────────────────────────────────
    json notifyPayload = {
        patientId: req.patientId,
        message:   string `Your prescription for ${req.medication} has been sent to the pharmacy. Ref: ${pharmacyRef}`
    };

    json|http:ClientError notifyResponse = pharmacyClient->post("/notify", notifyPayload);

    steps["patientNotified"] = {
        status:  notifyResponse is http:ClientError ? "FAILED" : "SENT",
        channel: "SMS"
    };

    // ── Step 4: Audit Log ─────────────────────────────────────────────────────
    error? auditResult = writeAuditLog({
        traceId, prescriptionId, actorId,
        actorRole: "Doctor", action: "SUBMIT_PRESCRIPTION",
        status: "COMPLETED",
        timestamp: time:utcToString(time:utcNow()),
        metadata: {"pharmacyRef": pharmacyRef, "medication": req.medication}
    });

    steps["auditLogged"] = {
        status:    auditResult is error ? "FAILED" : "WRITTEN",
        timestamp: time:utcToString(time:utcNow())
    };

    log:printInfo("Workflow completed", traceId = traceId, prescriptionId = prescriptionId);

    return {
        prescriptionId,
        traceId,
        workflowStatus: "COMPLETED",
        steps
    };
}
```

**Step 4.5 — `main.bal`** — HTTP listener

```ballerina
import ballerina/http;

service /api/v1 on new http:Listener(8080) {

    resource function post prescriptions(
        http:Request req,
        @http:Header string? x\-actor\-id
    ) returns WorkflowResult|http:InternalServerError|http:BadRequest {

        json|error body = req.getJsonPayload();
        if body is error {
            return <http:BadRequest>{ body: { message: "Invalid JSON body" }};
        }

        PrescriptionRequest|error prescReq = body.cloneWithType(PrescriptionRequest);
        if prescReq is error {
            return <http:BadRequest>{ body: { message: "Missing required fields: patientId, medication, dosage" }};
        }

        string actorId = x\-actor\-id ?: "UNKNOWN";
        WorkflowResult|error result = runPrescriptionWorkflow(prescReq, actorId);

        if result is error {
            return <http:InternalServerError>{ body: { message: result.message() }};
        }
        return result;
    }

    resource function get audit/[string traceId]() returns AuditEntry[]|http:NotFound {
        AuditEntry[] entries = getAuditByTraceId(traceId);
        if entries.length() == 0 {
            return <http:NotFound>{ body: { message: "No audit records found for traceId: " + traceId }};
        }
        return entries;
    }

    resource function get health() returns json {
        return { status: "healthy", service: "ballerina-orchestrator" };
    }
}
```

**Step 4.6 — Build and run**

```bash
cd ballerina/prescription-orchestrator
bal build
bal run
# Verify: curl http://localhost:8080/api/v1/health
```

> ✅ **Checkpoint:** POST a test prescription — verify all 4 workflow steps appear in the response.

---

### Phase 5 — WSO2 API Manager
> ⏱ ~3 hours | Day 2 Morning

**Step 5.1 — Create APIs in Publisher**

Open: `https://localhost:9444/publisher` → Login: `admin / admin`

For each API: **Create API → Import OpenAPI → upload the yaml from `api-manager/apis/`**

Set these backends:
```
AppointmentAPI  → Backend: http://clinic-service:5001
PrescriptionAPI → Backend: http://ballerina:8080
PharmacyAPI     → Backend: http://pharmacy-service:5003
```

**Step 5.2 — Configure Throttle Policies**

Go to: **Admin Portal** → `https://localhost:9444/admin`

**Rate Limiting → Subscription Policies → Add Policy**

```
Policy: DoctorTier   | Request Count: 100 | Unit Time: 1 minute
Policy: PatientTier  | Request Count: 10  | Unit Time: 1 minute
Policy: PharmaTier   | Request Count: 50  | Unit Time: 1 minute
```

**Step 5.3 — Scope Authorization per Endpoint**

In Publisher, for PrescriptionAPI → Resources:

```
POST /prescriptions        → Required Scope: prescription:write
GET  /prescriptions/{id}   → Required Scope: prescription:read
GET  /audit/{traceId}      → Required Scope: prescription:read
```

For AppointmentAPI:
```
GET  /appointments         → Required Scope: appointment:read
POST /appointments         → Required Scope: appointment:write
```

**Step 5.4 — Connect to Identity Server**

Go to: **Publisher → Settings → Key Managers**

Verify WSO2 IS is listed and active. If not:
```
Add Key Manager:
  Type: WSO2 Identity Server
  Well-known URL: https://wso2is:9443/oauth2/token/.well-known/openid-configuration
```

**Step 5.5 — Deploy and Publish**

For each API:
1. **Deploy** → Select gateway → Deploy
2. **Lifecycle → Publish**

Check Developer Portal: `https://localhost:9444/devportal` — all 3 APIs should be visible.

**Step 5.6 — Create Subscriptions**

In Dev Portal, for each API:
- Subscribe with the MediConnect application
- Select the correct throttle tier

> ✅ **Checkpoint:** `curl -H "Authorization: Bearer PATIENT_TOKEN" -X POST https://localhost:8243/prescription/v1/prescriptions` → returns **403 Forbidden** (patient doesn't have `prescription:write` scope).

---

### Phase 6 — Postman Test Suite
> ⏱ ~1 hour | Day 2 Afternoon

**Create collection:** `MediConnect` with these 3 folders:

**Folder 1: 🔐 Authentication**
```
1. Get Doctor Token   POST https://localhost:9443/oauth2/token
   Body: grant_type=password&username=doctor1&password=Doctor@123!
         &scope=prescription:write appointment:write
         &client_id={{clientId}}&client_secret={{clientSecret}}
   Tests: pm.environment.set("doctorToken", pm.response.json().access_token);

2. Get Patient Token  (same, username=patient1, scope=prescription:read appointment:read)
   Tests: pm.environment.set("patientToken", pm.response.json().access_token);

3. Get Pharma Token   (same, username=pharma1, scope=prescription:fill)
   Tests: pm.environment.set("pharmaToken", pm.response.json().access_token);

4. Inspect Doctor JWT GET https://localhost:9443/oauth2/introspect
   (Verify scope field shows prescription:write)
```

**Folder 2: ✅ Happy Path Workflow**
```
1. Book Appointment        POST :8243/appointment/v1/appointments
   Auth: Bearer {{doctorToken}}

2. Submit Prescription     POST :8243/prescription/v1/prescriptions
   Auth: Bearer {{doctorToken}}
   Tests: pm.environment.set("traceId", pm.response.json().traceId);
          pm.environment.set("prescriptionId", pm.response.json().prescriptionId);

3. Get Audit Trail         GET :8243/prescription/v1/audit/{{traceId}}
   Auth: Bearer {{doctorToken}}

4. Pharmacist Fills Rx     POST :8243/pharmacy/v1/prescriptions/{{prescriptionId}}/fill
   Auth: Bearer {{pharmaToken}}

5. Patient Checks Status   GET :8243/prescription/v1/prescriptions/{{prescriptionId}}
   Auth: Bearer {{patientToken}}
```

**Folder 3: 🚫 Security & Throttle Tests**
```
1. Patient tries to prescribe   → Expect 403 Forbidden
2. No token at all              → Expect 401 Unauthorized
3. Expired token                → Expect 401 (use a fake token)
4. Rate limit test (run 15x)    → Expect 429 after 10th request (patient tier)
```

**Environment variables:**
```json
{
  "baseIsUrl":     "https://localhost:9443",
  "baseApimUrl":   "https://localhost:8243",
  "clientId":      "YOUR_CLIENT_ID_HERE",
  "clientSecret":  "YOUR_CLIENT_SECRET_HERE",
  "doctorToken":   "",
  "patientToken":  "",
  "pharmaToken":   "",
  "traceId":       "",
  "prescriptionId": ""
}
```

> ✅ **Checkpoint:** All happy path tests green. 403 and 429 tests confirm security and throttling work.

---

### Phase 7 — React Dashboard (Bonus)
> ⏱ ~2 hours | Day 2 Afternoon/Evening

```bash
cd react-dashboard
npm create vite@latest . -- --template react
npm install axios
npm run dev   # http://localhost:3000
```

**Key components to build:**

1. **Login page** — role selector (Doctor / Patient / Pharmacist) → fetches token from WSO2 IS
2. **WorkflowTracker** — shows each Ballerina step with ✅/❌/⏳ status indicators in real-time
3. **AuditLog viewer** — enter a traceId → displays complete audit trail in a clean table
4. **RateLimitMeter** — reads `X-RateLimit-Remaining` response headers from APIM → shows a live progress bar

---

## 📚 API Reference

### Appointment API — `https://localhost:8243/appointment/v1`

| Method | Endpoint | Scope | Description |
|---|---|---|---|
| `GET` | `/appointments` | `appointment:read` | List all appointments |
| `POST` | `/appointments` | `appointment:write` | Book appointment |
| `GET` | `/appointments/{id}` | `appointment:read` | Get appointment detail |
| `DELETE` | `/appointments/{id}` | `appointment:write` | Cancel appointment |

### Prescription API — `https://localhost:8243/prescription/v1`

| Method | Endpoint | Scope | Description |
|---|---|---|---|
| `POST` | `/prescriptions` | `prescription:write` | Submit prescription (triggers Ballerina workflow) |
| `GET` | `/prescriptions/{id}` | `prescription:read` | Get prescription status |
| `GET` | `/audit/{traceId}` | `prescription:read` | Get full immutable audit trail |

### Pharmacy API — `https://localhost:8243/pharmacy/v1`

| Method | Endpoint | Scope | Description |
|---|---|---|---|
| `GET` | `/prescriptions/queue` | `prescription:fill` | View pending prescriptions |
| `POST` | `/prescriptions/{id}/fill` | `prescription:fill` | Mark as dispensed |

---

## 🔐 Security Model

```
User Role     Token Scopes Granted                    Throttle Tier
─────────     ──────────────────────────────────────  ─────────────
Doctor        appointment:read/write                  DoctorTier
              prescription:read/write                 100 req/min

Patient       appointment:read                        PatientTier
              prescription:read                       10 req/min

Pharmacist    prescription:read/fill                  PharmaTier
                                                      50 req/min
```

**Enforcement layers:**
1. WSO2 IS validates credentials and issues scoped JWT
2. WSO2 APIM Gateway validates JWT signature on every request
3. APIM checks required scope on each endpoint
4. APIM enforces throttle tier per token/subscription
5. Ballerina validates actor from `X-Actor-Id` header for audit logging

---

## 🎤 Demo Script

> Run these steps in order for a confident, impressive 10-minute demo.

```
1. [Show WSO2 IS Console]
   "We have 3 users — doctor1, patient1, pharma1 — each assigned a different role.
   Those roles map to OAuth2 scopes that control exactly what each user can do."

2. [Postman → Get Doctor Token → decode at jwt.io]
   "See the 'scope' claim — prescription:write is only in the doctor's token.
   This is enforced by WSO2 Identity Server, not by our application code."

3. [Show WSO2 APIM Developer Portal]
   "Three published APIs, each with scope requirements and throttle policies
   visible to developers. This is enterprise API governance."

4. [Postman → Book Appointment → Submit Prescription]
   "Watch the response — it's not just 'created'. It's a complete workflow trace:
   insurance approved, pharmacy notified, patient alerted, audit written."

5. [GET /audit/{traceId}]
   "This immutable audit record is a real compliance requirement in healthcare.
   Every prescription is fully traceable — who submitted it, when, and the
   result of every automated step."

6. [Postman → Patient tries to submit prescription → 403]
   "Same endpoint, patient token — 403 Forbidden. The scope check at the gateway
   prevents this before it even reaches our services."

7. [Postman → Fire 15 rapid requests as patient → 429]
   "Request 11 returns 429 Too Many Requests. The throttle policy is live —
   not just configured, but actively enforced."
```

---

## 🔧 Troubleshooting

| Problem | Solution |
|---|---|
| WSO2 containers stuck starting | Run `docker logs wso2is` — check for port 9443/9444 conflicts |
| 401 from APIM even with token | Token may be expired (default 300s). Re-run the Auth Postman requests. |
| Ballerina build fails | Run `bal build` inside the project dir. Check `types.bal` is imported. |
| 403 for doctor on prescription | Verify scope mapping in IS console — `prescription:write` must be assigned to Doctor role |
| Throttle policy not working | Policies sync every 60s. Wait 1 minute after creating a policy. |
| CORS error from React UI | Add `http://localhost:3000` to Allowed Origins in IS `deployment.toml` |
| Insurance always rejects | Set `APPROVE_ALL=true` env var in `docker-compose.yml` for the insurance service |
| Pharmacy service not receiving | Check Ballerina env vars `PHARMACY_URL` points to `http://pharmacy-service:5003` |

---

## 📄 License

MIT — see [LICENSE](LICENSE)

---

<div align="center">

Built with ❤️ using **WSO2 Identity Server** · **WSO2 API Manager** · **Ballerina** · **Python Flask**

*MediConnect — Enterprise API Integration Project 2025*

</div>
