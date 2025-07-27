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

# Check if SSL is enabled
SSL_ENABLED=$(bashio::config 'ssl_enabled')
echo "SSL enabled: $SSL_ENABLED"

# Check if authentication is configured
if bashio::config.has_value 'username' && bashio::config.has_value 'password'; then
    echo "Authentication enabled"
    USERNAME=$(bashio::config 'username')
    PASSWORD=$(bashio::config 'password')
    
    # Create htpasswd file for authentication
    mkdir -p /etc/docker/registry
    htpasswd -Bbn "$USERNAME" "$PASSWORD" > /etc/docker/registry/htpasswd
    echo "Authentication file created"
else
    echo "No authentication configured - registry will be open"
fi

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
EOF

# Add SSL configuration if enabled
if [ "$SSL_ENABLED" = "true" ]; then
    echo "Configuring SSL..."
    cat >> /etc/docker/registry/config.yml << EOF
  tls:
    certificate: /ssl/fullchain.pem
    key: /ssl/privkey.pem
EOF
fi

# Add authentication if configured
if bashio::config.has_value 'username' && bashio::config.has_value 'password'; then
    cat >> /etc/docker/registry/config.yml << EOF
auth:
  htpasswd:
    realm: basic-realm
    path: /etc/docker/registry/htpasswd
EOF
fi

# Add health check
cat >> /etc/docker/registry/config.yml << EOF
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