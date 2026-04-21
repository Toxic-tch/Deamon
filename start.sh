#!/bin/sh

echo "=== Starting Pterodactyl Wings ==="
echo "=== Panel: https://hym5hs-5080.csb.app ==="

# Set timezone
export TZ=UTC

# Start Docker daemon in background
echo ">>> Starting Docker daemon..."
(dockerd \
    --iptables=false \
    --ip6tables=false \
    --bridge=none \
    --storage-driver=vfs \
    --host=unix:///var/run/docker.sock \
    &>/var/log/dockerd.log &)

# Wait for Docker to be ready (up to 90 seconds)
echo ">>> Waiting for Docker daemon..."
READY=0
i=0
while [ $i -lt 45 ]; do
    if docker info >/dev/null 2>&1; then
        READY=1
        echo ">>> Docker is ready!"
        break
    fi
    sleep 2
    i=$((i + 1))
done

if [ "$READY" = "0" ]; then
    echo ">>> WARNING: Docker did not start. Trying anyway..."
    echo ">>> Docker log:"
    tail -20 /var/log/dockerd.log
fi

# Update Wings config port to match Render PORT env
WINGS_PORT="${PORT:-8080}"
echo ">>> Using port: $WINGS_PORT"
sed -i "s/port: 8080/port: $WINGS_PORT/" /etc/pterodactyl/config.yml

# Show Wings config
echo ">>> Wings config loaded."
echo ">>> Starting Wings..."

# Start Wings
exec /usr/local/bin/wings
