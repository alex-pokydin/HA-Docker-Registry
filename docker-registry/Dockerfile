FROM homeassistant/amd64-base:latest
RUN apk add --no-cache docker
COPY run.sh /run.sh
RUN chmod +x /run.sh
ENTRYPOINT ["/run.sh"]
