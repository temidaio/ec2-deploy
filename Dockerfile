FROM alpine:latest

RUN apk add  --no-cache \
    bash \
    ssh
    
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]