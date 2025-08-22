#!/usr/bin/with-contenv bashio

DEVICE=$(bashio::config 'device')
CONFIG_FILE="/data/gammurc"

# Vytvor config, ak neexistuje
mkdir -p /data
cat <<EOF > "$CONFIG_FILE"
[gammu]
device = $DEVICE
connection = at115200
EOF

echo "Používam modem na $DEVICE"

# Otestuj modem, ale container nespadne pri chybe
gammu -c "$CONFIG_FILE" --identify || echo "Chyba: nepodarilo sa identifikovať modem"

# Udrží container bežať
tail -f /dev/null
