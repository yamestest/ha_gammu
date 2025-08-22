ARG BUILD_FROM=ghcr.io/hassio-addons/base:14.0.0
FROM ${BUILD_FROM}

# Inštalácia gammu a ncat
RUN apk add --no-cache gammu nmap-ncat bash

# Skopíruj run.sh a sms_handler.sh
COPY run.sh /run.sh
COPY sms_handler.sh /usr/local/sbin/sms_handler.sh
RUN chmod a+x /run.sh /usr/local/sbin/sms_handler.sh

# Otvor port pre SMS server
EXPOSE 5000

# Spust run.sh pri štarte
CMD [ "/run.sh" ]
