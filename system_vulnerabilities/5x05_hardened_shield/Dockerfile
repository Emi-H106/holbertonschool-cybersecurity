# syntax=docker/dockerfile:1

FROM debian:bookworm-slim

LABEL org.opencontainers.image.title="NovaTech Hardened Shield" \
      org.opencontainers.image.description="Hardened web and SSH container" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.vendor="NovaTech Solutions"

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

# Install only required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      nginx \
      openssh-server \
      ca-certificates \
      curl \
      python3 \
      libpam-pwquality \
      libpam-modules && \
    rm -rf /var/lib/apt/lists/*

# Create non-root application user
RUN groupadd -g 10001 appgroup && \
    useradd -m -u 10001 -g appgroup \
      -s /bin/sh appuser && \
    passwd -l root && \
    mkdir -p /run/sshd /app /var/cache/nginx && \
    chown -R appuser:appgroup \
      /app /var/cache/nginx

# Copy security scripts and configuration
COPY --chmod=755 scripts/ /opt/security/scripts/
COPY config/ /opt/security/config/

# Apply system hardening during build
RUN /opt/security/scripts/init-hardening.sh
RUN /opt/security/scripts/init-identity.sh

# Configure Nginx for non-root execution
RUN sed -i '/^user /d' /etc/nginx/nginx.conf && \
    sed -i 's/listen 80 default_server;/listen 8080 default_server;/' \
      /etc/nginx/sites-available/default && \
    sed -i 's/listen \[::\]:80 default_server;/listen [::]:8080 default_server;/' \
      /etc/nginx/sites-available/default && \
    mkdir -p /tmp/nginx && \
    sed -i 's|pid /run/nginx.pid;|pid /tmp/nginx/nginx.pid;|' \
      /etc/nginx/nginx.conf && \
    chown -R appuser:appgroup /tmp/nginx /var/log/nginx

# Restrict SSH authentication
RUN printf '\nPermitRootLogin no\nPasswordAuthentication no\nPubkeyAuthentication yes\n' \
      >> /etc/ssh/sshd_config

# Expose web and SSH ports
EXPOSE 8080 2222

# Health monitoring
HEALTHCHECK --interval=30s --timeout=5s \
  --start-period=20s --retries=3 \
  CMD curl -fsS http://127.0.0.1:8080/ > /dev/null || exit 1

# Run as non-root
USER appuser

CMD ["/opt/security/scripts/init-services.sh"]
