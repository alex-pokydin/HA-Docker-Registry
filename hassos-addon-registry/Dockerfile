# Use the Home Assistant base image for your architecture
ARG BUILD_FROM
FROM $BUILD_FROM

# Debug: Print build information
RUN echo "=== BUILD DEBUG INFO ===" && \
    echo "Build architecture: $(uname -m)" && \
    echo "Build platform: $(uname -s)" && \
    echo "Build kernel: $(uname -r)" && \
    echo "========================"

# Install necessary dependencies
RUN apk add --no-cache curl file

# Determine architecture and download appropriate registry binary
RUN echo "=== ARCHITECTURE DETECTION ===" && \
    case "$(uname -m)" in \
        x86_64) ARCH=amd64; echo "Detected x86_64 -> amd64" ;; \
        aarch64) ARCH=arm64; echo "Detected aarch64 -> arm64" ;; \
        armv7l) ARCH=armv7; echo "Detected armv7l -> armv7" ;; \
        armv6l) ARCH=armv6; echo "Detected armv6l -> armv6" ;; \
        *) echo "Unsupported architecture: $(uname -m)"; exit 1 ;; \
    esac && \
    echo "Downloading registry for architecture: $ARCH" && \
    echo "URL: https://github.com/distribution/distribution/releases/download/v3.0.0/registry_3.0.0_linux_${ARCH}.tar.gz" && \
    curl -L "https://github.com/distribution/distribution/releases/download/v3.0.0/registry_3.0.0_linux_${ARCH}.tar.gz" | tar xz && \
    echo "Registry binary downloaded successfully" && \
    mv registry /usr/local/bin/ && \
    chmod +x /usr/local/bin/registry && \
    echo "Registry binary installed at /usr/local/bin/registry" && \
    echo "Registry binary info:" && \
    ls -la /usr/local/bin/registry && \
    file /usr/local/bin/registry && \
    echo "=============================="

# Create configuration and data directories
RUN mkdir -p /etc/docker/registry /var/lib/registry

# Copy the run script
COPY run.sh /

# Make the run script executable
RUN chmod +x /run.sh

# Set the run script as the entrypoint
CMD ["/run.sh"]