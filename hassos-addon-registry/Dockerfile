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
RUN apk add --no-cache curl file python3

# Create necessary directories
RUN mkdir -p /var/lib/registry /etc/docker/registry

# Copy the run script
COPY run.sh /

# Make the run script executable
RUN chmod +x /run.sh

# Set the run script as the entrypoint
CMD ["/run.sh"]