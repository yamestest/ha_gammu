#!/usr/bin/with-contenv bashio
DEVICE=$(bashio::config 'device')

echo "Používam modem na $DEVICE"
/usr/bin/gammu --device "$DEVICE" --identify

# Tu môžeš spustiť službu, ktorá počúva na SMS
