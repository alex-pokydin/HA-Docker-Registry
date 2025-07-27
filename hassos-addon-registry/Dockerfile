# Use the Home Assistant base image for your architecture
ARG BUILD_FROM
FROM $BUILD_FROM

# Install necessary dependencies
RUN apk add --no-cache python3

# Create necessary directories
RUN mkdir -p /var/lib/registry

# Copy the run script
COPY run.sh /

# Make the run script executable
RUN chmod +x /run.sh