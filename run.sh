#!/usr/bin/with-contenv bashio
set -e

DEVICE=$(bashio::config 'device')
CONFIG_FILE="/data/gammurc"

# Vytvor priečinky pre gammu
mkdir -p /data/inbox /data/outbox /data/sent /data/errors

# Vytvor základný gammu config, aby --identify fungovalo
cat <<EOF > "$CONFIG_FILE"
[gammu]
device = $DEVICE
connection = at115200
EOF

echo "Používam modem na $DEVICE"

# Test modemu cez konfiguráciu
/usr/bin/gammu -c "$CONFIG_FILE" --identify || echo "Chyba: nepodarilo sa identifikovať modem"

# Spusti ncat SMS server
PORT=5000
echo "Spúšťam minimalistický SMS server na porte $PORT"
/usr/bin/ncat -kl $PORT -c /usr/local/sbin/sms_handler.sh &

# Container drží bežať
tail -f /dev/null
