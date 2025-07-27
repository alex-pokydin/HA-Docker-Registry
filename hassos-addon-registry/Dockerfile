# Use the Home Assistant base image for your architecture
ARG BUILD_FROM
FROM $BUILD_FROM

# Install necessary dependencies
RUN apk add --no-cache docker

# Copy the run.sh script to the container
COPY run.sh /

# Ensure the run.sh script is executable
RUN chmod a+x /run.sh

# Set the run.sh script as the entrypoint for the container
CMD ["/run.sh"]