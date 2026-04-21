FROM docker:dind

# Install curl and ca-certificates for downloading Wings
RUN apk add --no-cache curl ca-certificates tzdata

# Create Wings directories
RUN mkdir -p /etc/pterodactyl /var/lib/pterodactyl/volumes /var/log/pterodactyl /tmp/pterodactyl

# Download Wings v1.11.10 for linux amd64
RUN curl -fsSL -o /usr/local/bin/wings \
    "https://github.com/pterodactyl/wings/releases/download/v1.11.10/wings_linux_amd64" && \
    chmod +x /usr/local/bin/wings

# Copy Wings config
COPY config.yml /etc/pterodactyl/config.yml

# Copy start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose ports
EXPOSE 8080 2022 2375 2376

# Start everything
CMD ["/start.sh"]
