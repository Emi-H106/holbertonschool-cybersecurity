# NovaTech Hardened Shield

## 1. Project Description

NovaTech Hardened Shield is a Docker-based Linux security hardening project developed as part of the Holberton School Cybersecurity curriculum.

The project demonstrates a defense-in-depth approach to protecting containerized services through system hardening, identity and access management, secure service configuration, runtime restrictions, and automated security auditing.

The environment uses Debian Bookworm Slim and includes Nginx and OpenSSH.

### Objectives

- Reduce the attack surface of a Linux container.
- Implement secure authentication and access controls.
- Apply container runtime security restrictions.
- Automate security configuration and auditing.
- Document security controls, compliance findings, and remaining risks.

## 2. Quick Start Guide

### Prerequisites

- Docker Engine or Docker Desktop
- Docker Compose
- Git
- Available host ports 80 and 22

### Clone the Repository

```bash
git clone https://github.com/<YOUR_USERNAME>/holbertonschool-cybersecurity.git
cd holbertonschool-cybersecurity/system_vulnerabilities/5x05_hardened_shield
```

Replace `<YOUR_USERNAME>` with your GitHub username.

### Build and Start

```bash
docker compose config -q
docker compose up -d --build
```

### Check Container Status

```bash
docker compose ps -a
docker compose logs --tail=50
```

### Test the Web Server

```bash
curl -I http://localhost:80
```

A successful HTTP response indicates that the web endpoint is available.

**Important:** The current service initialization script requires root privileges, while the Dockerfile specifies a non-root user. The complete non-root deployment has not yet been validated and may fail to start.

## 3. File Structure
```text
5x05_hardened_shield/
├── Dockerfile
├── docker-compose.yml
├── SECURITY.md
├── COMPLIANCE_REPORT.md
├── audit_result.md
├── README.md
├── scripts/
│   ├── init-hardening.sh
│   ├── init-identity.sh
│   ├── init-services.sh
│   └── audit.py
└── config/
```

### Main Files

| File | Description |
|---|---|
| `Dockerfile` | Builds the hardened Debian container image |
| `docker-compose.yml` | Defines container services and runtime restrictions |
| `scripts/init-hardening.sh` | Applies system hardening checks and configurations |
| `scripts/init-identity.sh` | Configures PAM, password policies, and SSH security |
| `scripts/init-services.sh` | Starts and checks Nginx and SSH services |
| `scripts/audit.py` | Runs automated security checks |
| `scripts/audit_result.md` | Contains generated audit findings |
| `SECURITY.md` | Documents the security architecture and procedures |
| `COMPLIANCE_REPORT.md` | Summarizes compliance status and residual risks |
| `config/` | Contains additional configuration files |

## 4. Build and Run Instructions

### Build the Image

```bash
docker compose build
```

### Start the Container

```bash
docker compose up -d
```

### Inspect Running Containers

```bash
docker compose ps -a
```

### View Logs

```bash
docker compose logs --tail=100
```

### Verify HTTP Connectivity

```bash
curl -I http://localhost:80
```

### Verify SSH Port Connectivity

```bash
docker exec novatech-secure \
  bash -c 'echo > /dev/tcp/127.0.0.1/2222'
```

This checks TCP connectivity only and does not validate SSH authentication.

### Stop the Environment

```bash
docker compose down
```

### Rebuild with Updated Base Images

```bash
docker compose build --pull
docker compose up -d
```

## 5. Security Features Summary

### System Hardening

- Kernel security parameter checks.
- IP forwarding and ICMP redirect restrictions.
- TCP SYN cookie verification.
- Secure filesystem permissions.
- SUID/SGID auditing.
- Legal warning banner.

### Identity and Access Management

- Minimum password length of 12 characters.
- Uppercase, lowercase, numeric, and special-character requirements.
- PAM password quality configuration.
- Account lockout configuration.
- Root password locking.

### SSH Security

- Root login disabled.
- Password authentication disabled.
- Public-key authentication enabled.
- Keyboard-interactive authentication disabled.
- SSH configured on port 2222.

### Docker Runtime Security

- Minimal Debian base image.
- Dedicated non-root user defined in the Dockerfile.
- Restricted Linux capabilities.
- No-new-privileges security option.
- Read-only root filesystem.
- Temporary writable mounts and persistent volumes.
- CPU, memory, and process limits.
- HTTP health check.

### Security Auditing

The project includes an automated Python security audit covering:

1. Kernel Hardening
2. Filesystem Security
3. Identity Security
4. Service Security
5. Container Security

The audit generates a Markdown report with individual PASS/FAIL results and an overall score.

The project defines an 80% audit passing threshold. An earlier audit achieved 83.9%, but this result must be revalidated against the final runtime configuration.

## 6. Known Limitations

- The service initialization script requires root privileges.
- Non-root startup of the complete container has not been confirmed.
- End-to-end SSH public-key authentication has not been tested.
- PAM account lockout requires functional verification.
- Earlier audit results may not reflect the final deployment configuration.

These limitations should be resolved before production use.

## 7. Additional Documentation

- [Security Documentation](SECURITY.md)
- [Compliance Report](COMPLIANCE_REPORT.md)

## 8. Conclusion

NovaTech Hardened Shield demonstrates practical Linux and Docker security techniques, including system hardening, access restrictions, container isolation, and automated auditing.

The project serves as a cybersecurity training environment and requires additional integration testing before production deployment.