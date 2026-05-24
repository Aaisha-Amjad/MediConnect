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

@app.route('/notifications', methods=['GET'])
def list_notifications():
    return jsonify(notifications)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5003, debug=True)