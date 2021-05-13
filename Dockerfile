FROM alpine:latest

RUN apk add  --no-cache \
    bash \
    openssh

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]