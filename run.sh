#!/usr/bin/with-contenv bashio

# Získať device z konfigurácie add-onu
DEVICE=$(bashio::config 'device')

echo "Používam modem na $DEVICE"

# Vytvoriť konfiguračný súbor pre Gammu, ak ešte neexistuje
CONFIG_FILE="/data/gammurc"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Vytváram konfiguračný súbor $CONFIG_FILE"
    cat <<EOF > "$CONFIG_FILE"
[gammu]
device = $DEVICE
connection = at115200
EOF
fi

# Test pripojenia modemu
echo "Testujem modem..."
gammu -c "$CONFIG_FILE" --identify

if [ $? -eq 0 ]; then
    echo "Modem je pripravený ✅"
else
    echo "Chyba: modem sa nepodarilo identifikovať ❌"
fi

# Tu môžeš spustiť službu, ktorá počúva na SMS
# Príklad:
# gammu-smsd -c /data/gammu-smsdrc
