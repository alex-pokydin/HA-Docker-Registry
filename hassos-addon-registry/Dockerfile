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

# Copy the run script
COPY run.sh /

# Make the run script executable
RUN chmod +x /run.sh

# Set the run script as the entrypoint
ENTRYPOINT ["/run.sh"]