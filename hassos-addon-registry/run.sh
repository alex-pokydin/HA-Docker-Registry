#!/command/with-contenv bashio
# ==============================================================================
# Start Docker Registry
# ==============================================================================

# Fetch the configured port from the environment
REGISTRY_PORT=$(bashio::config 'registry_port')

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

# Run a simple HTTP server
cd /var/lib/registry
exec python3 -m http.server ${REGISTRY_PORT} 