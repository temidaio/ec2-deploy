FROM alpine:latest

RUN apk add  --no-cache \
    bash \
    openssh \
    scp

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]