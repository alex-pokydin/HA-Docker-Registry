#!/command/with-contenv bashio
# ==============================================================================
# Start Docker Registry
# ==============================================================================

# Debug: Print current process information
echo "=== DEBUG INFO ==="
echo "Current PID: $$"
echo "Parent PID: $PPID"
echo "Current user: $(whoami)"
echo "Current working directory: $(pwd)"
echo "Environment variables:"
env | sort
echo "=================="

# Debug: Check if bashio is available
echo "Checking bashio availability..."
if command -v bashio >/dev/null 2>&1; then
    echo "bashio is available"
else
    echo "bashio is NOT available"
fi

# Debug: Check if registry binary exists
echo "Checking registry binary..."
if [ -f "/usr/local/bin/registry" ]; then
    echo "Registry binary exists at /usr/local/bin/registry"
    echo "Registry binary permissions: $(ls -la /usr/local/bin/registry)"
    echo "Registry binary architecture: $(file /usr/local/bin/registry)"
else
    echo "Registry binary NOT found at /usr/local/bin/registry"
fi

# Debug: Check s6-overlay directories
echo "Checking s6-overlay directories..."
if [ -d "/run/s6" ]; then
    echo "s6 directory exists"
    ls -la /run/s6/ 2>/dev/null || echo "Cannot list /run/s6/"
else
    echo "s6 directory does NOT exist"
fi

# Fetch the configured port from the environment
echo "Fetching registry port configuration..."
REGISTRY_PORT=$(bashio::config 'registry_port')
echo "Configured registry port: $REGISTRY_PORT"

# Create dynamic configuration with the correct port
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

# Debug: Check if we can execute the registry
echo "Attempting to run registry..."
echo "Command: exec /usr/local/bin/registry serve /etc/docker/registry/config.yml"

# Run Docker Registry directly
exec /usr/local/bin/registry serve /etc/docker/registry/config.yml 