#!/bin/sh
set -e

echo "=== Starting Pterodactyl Wings ==="
echo "=== Panel: https://hym5hs-5080.csb.app ==="

# Set timezone
export TZ=UTC

# Start Docker daemon in background
echo ">>> Starting Docker daemon..."
dockerd \
    --iptables=false \
    --ip6tables=false \
    --bridge=none \
    --storage-driver=vfs \
    &>/var/log/dockerd.log &

DOCKER_PID=$!

# Wait for Docker to be ready (up to 60 seconds)
echo ">>> Waiting for Docker daemon..."
i=0
while [ $i -lt 30 ]; do
    if docker info &>/dev/null 2>&1; then
        echo ">>> Docker is ready!"
        break
    fi
    i=$((i + 1))
    if [ $i -eq 30 ]; then
        echo ">>> WARNING: Docker did not start in time."
        echo ">>> Docker log:"
        cat /var/log/dockerd.log
    fi
    sleep 2
done

# Show Wings config
echo ">>> Wings config loaded."
echo ">>> Starting Wings on port 8080..."

# Start Wings
exec /usr/local/bin/wings
