# Stage 1: Builder
FROM python:3.11-slim AS builder

# Install build tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    make \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

COPY requirements.txt .

# Install dependencies into a separate directory
RUN pip install --no-cache-dir \
    --prefix=/install \
    -r requirements.txt

# Stage 2: Runtime
FROM python:3.11-slim AS runtime

# Create non-root user
RUN groupadd -g 1000 appuser && \
    useradd -m -u 1000 -g appuser appuser

WORKDIR /app

# Copy only installed dependencies from builder
COPY --from=builder /install /usr/local

# Copy application
COPY --chown=appuser:appuser app.py .

# Never hardcode secrets in Dockerfiles.
# Pass secrets at runtime using environment variables
# or, preferably, a secrets management system.

USER appuser

EXPOSE 5000

# Check Flask health endpoint every 30 seconds
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:5000/health', timeout=5)" || exit 1

CMD ["python", "app.py"]
