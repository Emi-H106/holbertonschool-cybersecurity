
FROM python:3.11-slim

# Create non-root user with UID 1000
RUN groupadd -g 1000 appuser && \
    useradd -m -u 1000 -g appuser appuser

# Set working directory
WORKDIR /app

# Install application dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY --chown=appuser:appuser app.py .

# Switch to non-root user
USER appuser

# Expose Flask port
EXPOSE 5000

# Start application
CMD ["python", "app.py"]
