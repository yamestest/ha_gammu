#!/usr/bin/env bash

# Prečítaj HTTP POST JSON
read body
number=$(echo "$body" | sed -n 's/.*"number"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
message=$(echo "$body" | sed -n 's/.*"message"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')

if /usr/bin/gammu --sendsms TEXT "$number" -text "$message"; then
    echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\nOK"
else
    echo -e "HTTP/1.1 500 Internal Server Error\r\nContent-Type: text/plain\r\n\r\nFAIL"
fi
