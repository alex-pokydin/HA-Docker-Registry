# Use the Home Assistant base image for your architecture
ARG BUILD_FROM
FROM $BUILD_FROM

# Install necessary dependencies
RUN apk add --no-cache curl

# Determine architecture and download appropriate registry binary
RUN case "$(uname -m)" in \
        x86_64) ARCH=amd64 ;; \
        aarch64) ARCH=arm64 ;; \
        armv7l) ARCH=armv7 ;; \
        armv6l) ARCH=armv6 ;; \
        *) echo "Unsupported architecture: $(uname -m)"; exit 1 ;; \
    esac && \
    curl -L "https://github.com/distribution/distribution/releases/download/v3.0.0/registry_3.0.0_linux_${ARCH}.tar.gz" | tar xz && \
    mv registry /usr/local/bin/ && \
    chmod +x /usr/local/bin/registry

# Create configuration and data directories
RUN mkdir -p /etc/docker/registry /var/lib/registry

# Copy the run script
COPY run.sh /

# Make the run script executable
RUN chmod +x /run.sh

# Set the run script as the entrypoint
CMD ["/run.sh"]