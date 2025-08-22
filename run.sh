#!/usr/bin/with-contenv bashio
set -e

DEVICE=$(bashio::config 'device')

echo "Používam modem na $DEVICE"

# Test modemu
/usr/bin/gammu --identify --device "$DEVICE" || echo "Chyba: nepodarilo sa identifikovať modem"

# Spusti ncat SMS server
PORT=5000
echo "Spúšťam minimalistický SMS server na porte $PORT"
/usr/bin/ncat -kl $PORT -c /usr/local/sbin/sms_handler.sh &

# Container drží bežať
tail -f /dev/null
