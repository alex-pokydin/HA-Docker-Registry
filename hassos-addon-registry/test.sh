#!/bin/bash
# Test script to check registry connectivity

echo "=== REGISTRY CONNECTIVITY TEST ==="

# Check if registry is running
echo "1. Checking if registry process is running..."
if pgrep -f "registry serve" > /dev/null; then
    echo "   ✅ Registry process is running"
    ps aux | grep registry
else
    echo "   ❌ Registry process is NOT running"
fi

# Check if port is listening
echo "2. Checking if port 5000 is listening..."
if netstat -tlnp 2>/dev/null | grep :5000; then
    echo "   ✅ Port 5000 is listening"
else
    echo "   ❌ Port 5000 is NOT listening"
fi

# Check if we can connect locally
echo "3. Testing local connection..."
if curl -s http://localhost:5000/v2/ > /dev/null; then
    echo "   ✅ Local connection works"
else
    echo "   ❌ Local connection failed"
fi

# Check environment
echo "4. Environment check..."
echo "   REGISTRY_PORT: $REGISTRY_PORT"
echo "   Current directory: $(pwd)"
echo "   Registry binary: $(which registry 2>/dev/null || echo 'not found')"

echo "=== END TEST ===" 