#!/command/with-contenv bashio

echo "HELLO WORLD - ADD-ON IS STARTING!"
echo "Current time: $(date)"
echo "Current user: $(whoami)"
echo "Current directory: $(pwd)"

# Just sleep forever to keep the container running
echo "Sleeping forever to keep container alive..."
sleep infinity 