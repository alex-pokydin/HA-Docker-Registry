# Use the Home Assistant base image for your architecture
ARG BUILD_FROM
FROM $BUILD_FROM

# Install necessary dependencies
RUN apk add --no-cache curl

# Download and install Docker Registry
RUN curl -L https://github.com/distribution/distribution/releases/download/v2.8.2/registry_2.8.2_linux_amd64.tar.gz | tar xz && \
    mv registry /usr/local/bin/ && \
    chmod +x /usr/local/bin/registry

# Create configuration and data directories
RUN mkdir -p /etc/docker/registry /var/lib/registry

# Copy the run.sh script to the container
COPY run.sh /

# Ensure the run.sh script is executable
RUN chmod a+x /run.sh

# Set the run.sh script as the entrypoint for the container
ENTRYPOINT ["/run.sh"]