#!/command/with-contenv bashio
# ==============================================================================
# Start Docker Registry
# ==============================================================================

# Fetch the configured port from the environment
REGISTRY_PORT=$(bashio::config 'registry_port')

# Create dynamic configuration with the correct port
cat > /etc/docker/registry/config.yml << EOF
version: 0.1
log:
  level: debug
storage:
  filesystem:
    rootdirectory: /var/lib/registry
  delete:
    enabled: true
http:
  addr: :${REGISTRY_PORT}
  headers:
    X-Content-Type-Options: [nosniff]
health:
  storagedriver:
    enabled: true
    interval: 10s
    threshold: 3
EOF

# Run Docker Registry directly
exec /usr/local/bin/registry serve /etc/docker/registry/config.yml