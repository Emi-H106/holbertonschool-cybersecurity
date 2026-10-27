# Secure Python 3.11 Development Environment

FROM python:3.11-slim

# Image metadata
LABEL org.opencontainers.image.title="Secure Python Dev Environment"
LABEL org.opencontainers.image.description="Hardened Python 3.11 development environment"
LABEL org.opencontainers.image.version="1.0"
LABEL org.opencontainers.image.vendor="DevStream"

# Python configuration
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    VIRTUAL_ENV=/opt/venv \
    PATH="/opt/venv/bin:$PATH"

# Create non-root user
RUN groupadd -g 1000 devuser && \
    useradd -m -u 1000 -g devuser -s /bin/sh devuser

# Create virtual environment and install development tools
RUN python -m venv /opt/venv && \
    pip install --no-cache-dir \
        pylint \
        black \
        pytest \
        mypy

# Create workspace
RUN mkdir -p /workspace && \
    chown -R devuser:devuser /workspace /opt/venv

WORKDIR /workspace

# Run as non-root user
USER devuser

# Healthcheck: verify Python and pip are available
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import sys; import pip; sys.exit(0 if sys.version_info[:2] == (3, 11) else 1)" || exit 1

# Default command
CMD ["python", "--version"]
