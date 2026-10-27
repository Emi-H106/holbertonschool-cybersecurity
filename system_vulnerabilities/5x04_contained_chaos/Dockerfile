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
