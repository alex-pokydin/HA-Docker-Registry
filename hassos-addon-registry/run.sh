#!/command/with-contenv bashio
# ==============================================================================
# Start Docker Registry
# ==============================================================================

echo "=== STARTING DOCKER REGISTRY ==="
echo "Script started at: $(date)"
echo "Current user: $(whoami)"
echo "Working directory: $(pwd)"

# Fetch the configured port from the environment
REGISTRY_PORT=$(bashio::config 'registry_port')
echo "Registry port from config: $REGISTRY_PORT"

# Check if registry binary exists
if [ -f "/usr/local/bin/registry" ]; then
    echo "Registry binary: FOUND"
    echo "Registry binary info:"
    ls -la /usr/local/bin/registry
else
    echo "ERROR: Registry binary NOT found at /usr/local/bin/registry"
    exit 1
fi

# Create registry configuration
echo "Creating registry configuration..."
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

echo "Registry configuration created successfully"
echo "Starting Docker Registry on port ${REGISTRY_PORT}..."

# Run Docker Registry
exec /usr/local/bin/registry serve /etc/docker/registry/config.yml 