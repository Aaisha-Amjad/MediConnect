from flask import Flask, jsonify, request
from flask_cors import CORS
import uuid, datetime

app = Flask(__name__)
CORS(app)

appointments = {}
patients = {
    "P001": {"id": "P001", "name": "Alice Johnson", "dob": "1990-05-14", "insuranceId": "INS-001"},
    "P002": {"id": "P002", "name": "Bob Smith", "dob": "1985-11-22", "insuranceId": "INS-002"},
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

@app.route('/appointments/<appt_id>', methods=['DELETE'])
def cancel_appointment(appt_id):
    if appt_id not in appointments:
        return jsonify({"error": "Not found"}), 404
    appointments[appt_id]["status"] = "CANCELLED"
    return jsonify(appointments[appt_id])

@app.route('/patients/<patient_id>', methods=['GET'])
def get_patient(patient_id):
    patient = patients.get(patient_id)
    if not patient:
        return jsonify({"error": "Patient not found"}), 404
    return jsonify(patient)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=True)