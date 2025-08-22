ARG BUILD_FROM=ghcr.io/hassio-addons/base:14.0.0
FROM ${BUILD_FROM}

RUN apk add --no-cache gammu

COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
