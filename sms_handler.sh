#!/usr/bin/env bash

# Prečítaj HTTP POST JSON
read request

# Vyparsuj číslo a text
number=$(echo "$request" | grep -oP '(?<="number":")[^"]+')
message=$(echo "$request" | grep -oP '(?<="message":")[^"]+')

# Odošli SMS priamo cez gammu
if /usr/bin/gammu --sendsms TEXT "$number" -text "$message"; then
    echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\nOK"
else
    echo -e "HTTP/1.1 500 Internal Server Error\r\nContent-Type: text/plain\r\n\r\nFAIL"
fi
