#!/bin/bash
# Build and inspect DevStream's vulnerable Docker image

set -e

IMAGE="devstream-vulnerable:latest"

echo "Creating application files..."

cat > app.py <<'EOF'
from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def hello():
    return f"Hello from DevStream! DB: {os.environ.get('DB_HOST', 'unknown')}"

@app.route('/health')
def health():
    return "OK", 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOF
echo "  app.py: Created"

cat > requirements.txt <<'EOF'
flask==3.0.0
EOF
echo "  requirements.txt: Created"

cat > Dockerfile <<'EOF'
FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    curl \
    wget \
    vim \
    net-tools \
    iputils-ping \
    gcc \
    make \
    sudo

RUN echo 'root:devstream123' | chpasswd

ENV DB_HOST=prod-db.devstream.internal
ENV DB_USER=admin
ENV DB_PASSWORD=Sup3rS3cr3t!Pr0d

WORKDIR /app
COPY . /app

RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir -r requirements.txt

ENV PATH="/opt/venv/bin:$PATH"

EXPOSE 5000

CMD ["python3", "app.py"]
EOF
echo "  Dockerfile: Created"

echo "Building image..."
echo "  Image: $IMAGE"

if docker build -t "$IMAGE" .; then
    echo "  Build: SUCCESS"
else
    echo "  Build: FAILED"
    exit 1
fi

echo "Image Analysis:"

SIZE=$(docker image inspect "$IMAGE" \
    --format '{{.Size}}')

SIZE_MB=$(awk "BEGIN {printf \"%.0f\", $SIZE/1024/1024}")

echo "  Size: ${SIZE_MB} MB"
echo "  Base: ubuntu:latest"

USER_ID=$(docker run --rm --network none "$IMAGE" id -u)

if [ "$USER_ID" = "0" ]; then
    echo "  User: root (UID 0)"
else
    echo "  User: UID $USER_ID"
fi

echo "Environment Variables (EXPOSED SECRETS):"

docker image inspect "$IMAGE" \
    --format '{{range .Config.Env}}{{println .}}{{end}}' \
    | grep '^DB_' || true

echo "WARNING: This image contains hardcoded credentials!"
