#!/bin/bash
# Fetch the configured port from the environment
REGISTRY_PORT=$(hassio.addon.config.registry_port)

# Run Docker Registry and expose it on the configured port
docker run -d -p $REGISTRY_PORT:$REGISTRY_PORT --name registry registry:2