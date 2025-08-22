#!/bin/sh

# Prečítaj hlavičky a nájdi Content-Length
CONTENT_LENGTH=0
while IFS= read -r line; do
    [ "$line" = $'\r' ] && break
    case "$line" in
        Content-Length:*)
            CONTENT_LENGTH=$(echo "$line" | awk '{print $2}' | tr -d '\r')
            ;;
    esac
done

# Prečítaj presne CONTENT_LENGTH bajtov
body=$(head -c "$CONTENT_LENGTH")

# Parsovanie ako predtým
number=$(echo "$body"   | sed -n 's/.*"number"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
message=$(echo "$body"  | sed -n 's/.*"message"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')

if [ -n "$number" ] && [ -n "$message" ]; then
    if gammu -c /data/gammurc sendsms TEXT "$number" -text "$message" >/tmp/sms.log 2>&1; then
        echo -e "HTTP/1.1 200 OK\r"
        echo -e "Content-Type: text/plain\r"
        echo -e "\r"
        echo "OK"
    else
        echo -e "HTTP/1.1 500 Internal Server Error\r"
        echo -e "Content-Type: text/plain\r"
        echo -e "\r"
        echo "FAIL"
    fi
else
    echo -e "HTTP/1.1 400 Bad Request\r"
    echo -e "Content-Type: text/plain\r"
    echo -e "\r"
    echo "Missing number or message"
fi
