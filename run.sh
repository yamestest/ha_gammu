#!/usr/bin/with-contenv bashio

# Získaj device zo setupu HA
DEVICE=$(bashio::config 'device')
CONFIG_FILE="/data/gammurc"

# Vytvor config, ak neexistuje
mkdir -p /data
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

# Vytvor priečinky pre SMS
mkdir -p /data/inbox /data/outbox /data/sent /data/errors

echo "Používam modem na $DEVICE"

# Otestuj modem
gammu -c "$CONFIG_FILE" --identify || echo "Chyba: nepodarilo sa identifikovať modem"

# Spusti SMS daemon na pozadí
gammu-smsd -c "$CONFIG_FILE" &

# Container drží bežať
tail -f /dev/null
