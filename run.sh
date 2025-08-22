#!/usr/bin/with-contenv bashio
set -e

DEVICE=$(bashio::config 'device')
CONFIG_FILE="/data/gammurc"

# Vytvor config, ak neexistuje
mkdir -p /data/inbox /data/outbox /data/sent /data/errors

cat <<EOF > "$CONFIG_FILE"
[gammu]
device = $DEVICE
connection = at115200

[smsd]
service = files
logfile = /data/gammu-smsd.log
inboxpath = /data/inbox/
outboxpath = /data/outbox/
sentpath = /data/sent/
errorspath = /data/errors/
EOF

echo "Používam modem na $DEVICE"

# Otestuj modem, ale container nespadne pri chybe
/usr/bin/gammu -c "$CONFIG_FILE" --identify || echo "Chyba: nepodarilo sa identifikovať modem"

# Spusti gammu-smsd na pozadí
/usr/bin/gammu-smsd -c "$CONFIG_FILE" &

# Spusti Flask API pre posielanie SMS
cat <<'PYTHONCODE' > /data/send_sms_server.py
#!/usr/bin/env python3
from flask import Flask, request
import subprocess

app = Flask(__name__)

CONFIG_FILE = "/data/gammurc"

@app.route("/send_sms", methods=["POST"])
def send_sms():
    data = request.get_json()
    number = data.get("number")
    message = data.get("message")

    if not number or not message:
        return {"status": "error", "detail": "Missing number or message"}, 400

    try:
        subprocess.run(
            ["/usr/bin/gammu", "-c", CONFIG_FILE, "sendsms", "TEXT", number, "-text", message],
            check=True,
            timeout=10
        )
        return {"status": "ok", "sent": number}
    except Exception as e:
        return {"status": "fail", "detail": str(e)}, 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
PYTHONCODE

# Urob skript spustiteľným
chmod +x /data/send_sms_server.py

# Spusti Flask API na pozadí
python3 /data/send_sms_server.py &

# Container drží bežať
tail -f /dev/null
