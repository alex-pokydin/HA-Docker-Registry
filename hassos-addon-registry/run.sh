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
echo "=================="

# Debug: Check if bashio is available
echo "Checking bashio availability..."
if command -v bashio >/dev/null 2>&1; then
    echo "bashio is available"
else
    echo "bashio is NOT available"
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

# Create a simple registry configuration
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

# Try to run a simple HTTP server as a fallback
echo "Attempting to run a simple HTTP server as registry..."
echo "This is a minimal registry implementation for testing"

# Create a simple index page
cat > /var/lib/registry/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Docker Registry</title>
</head>
<body>
    <h1>Docker Registry</h1>
    <p>Registry is running on port ${REGISTRY_PORT}</p>
    <p>This is a minimal implementation for Home Assistant testing.</p>
</body>
</html>
EOF

# Run a simple HTTP server instead of the registry binary
echo "Starting simple HTTP server on port ${REGISTRY_PORT}..."
cd /var/lib/registry
exec python3 -m http.server ${REGISTRY_PORT} 