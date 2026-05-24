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
    medication = data.get("medication")

    approved = APPROVE_ALL or patient_id != "P999"

    return jsonify({
        "patientId": patient_id,
        "medication": medication,
        "approved": approved,
        "coveragePercent": 80 if approved else 0,
        "authCode": f"INS-{str(uuid.uuid4())[:6].upper()}" if approved else None,
        "reason": "Approved" if approved else "Patient not covered for this medication"
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5002, debug=True)