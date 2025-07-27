#!/command/with-contenv bashio
# ==============================================================================
# Start Docker Registry
# ==============================================================================

# Debug: Print startup information
echo "=== REGISTRY STARTUP DEBUG ==="
echo "Current PID: $$"
echo "Current user: $(whoami)"
echo "Working directory: $(pwd)"

# Fetch the configured port from the environment
REGISTRY_PORT=$(bashio::config 'registry_port')
echo "Configured registry port: $REGISTRY_PORT"

# Debug: Check if registry binary exists
if [ -f "/usr/local/bin/registry" ]; then
    echo "Registry binary found at /usr/local/bin/registry"
    echo "Registry binary permissions: $(ls -la /usr/local/bin/registry)"
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

echo "Registry configuration created:"
cat /etc/docker/registry/config.yml

# Debug: Check if directories exist
echo "Checking directories..."
ls -la /var/lib/registry/
ls -la /etc/docker/registry/

echo "Starting Docker Registry on port ${REGISTRY_PORT}..."
echo "Command: exec /usr/local/bin/registry serve /etc/docker/registry/config.yml"

# Run Docker Registry
exec /usr/local/bin/registry serve /etc/docker/registry/config.yml 