# NovaTech Hardened Shield — Security Documentation

## 1. Architecture Overview

NovaTech Hardened Shield is a Docker-based security hardening project using Debian Bookworm Slim.

The container includes:

- **Nginx:** Web server listening on port 8080.
- **OpenSSH:** SSH server configured on port 2222.
- **Docker Compose:** Container deployment and runtime security configuration.
- **Bash scripts:** Automated system hardening, identity configuration, and service management.
- **Python audit tool:** Automated security assessment and Markdown report generation.

### Network Configuration

| Host Port | Container Port | Service |
|---|---|---|
| 80 | 8080 | Nginx |
| 22 | 2222 | OpenSSH |

The Dockerfile defines a dedicated non-root user (`appuser`, UID 10001).

## 2. Security Controls

### System Hardening

The `init-hardening.sh` script implements:

- Kernel security parameter checks.
- IP forwarding and ICMP redirect restrictions.
- TCP SYN cookie verification.
- Secure filesystem permissions.
- SUID/SGID binary auditing.
- Legal login banner configuration.
- Unnecessary service auditing.

### Identity and Access Management

The `init-identity.sh` script configures:

- Password minimum length of 12 characters.
- Uppercase, lowercase, numeric, and special-character requirements.
- PAM password quality enforcement.
- Account lockout after repeated authentication failures.
- Root password locking.

### SSH Hardening

OpenSSH is configured with:

- Root login disabled.
- Password authentication disabled.
- Public-key authentication enabled.
- Keyboard-interactive authentication disabled.
- SSH port 2222.
- Legal warning banner.

### Container Security

Docker Compose defines:

- `cap_drop: ALL` to remove default Linux capabilities.
- Explicitly added capabilities where required.
- `no-new-privileges:true` to prevent privilege escalation.
- `read_only: true` to restrict filesystem modification.
- `tmpfs` mounts for temporary writable directories.
- Memory, CPU, and process limits.
- Named volumes for required persistent data.
- Supported network security sysctls.

**Known limitation:** The Dockerfile specifies a non-root user, but the current service initialization script requires root privileges. Complete non-root startup has not yet been validated.

## 3. Usage Instructions

### Prerequisites

- Docker Engine or Docker Desktop.
- Docker Compose.
- Available host ports 80 and 22.

### Build and Start

```bash
docker compose config -q
docker compose up -d --build
```

### Check Status

```bash
docker compose ps -a
docker compose logs --tail=50
```

### Test HTTP

```bash
curl -I http://localhost:80
```

### Test SSH Port

```bash
docker exec novatech-secure \
  bash -c 'echo > /dev/tcp/127.0.0.1/2222'
```

This checks port connectivity, not successful SSH authentication.

### Stop the Container

```bash
docker compose down
```

## 4. Audit Procedures

The project uses `audit.py` to evaluate five security categories:

1. Kernel Hardening
2. Filesystem Security
3. Identity Security
4. Service Security
5. Container Security

### Run the Audit

Copy the audit script into a running test container:

```bash
docker cp scripts/audit.py novatech-secure:/tmp/audit.py
```

Execute it:

```bash
docker exec -u root -w /tmp \
  novatech-secure python3 audit.py
```

Retrieve the generated report:

```bash
docker cp novatech-secure:/tmp/audit_result.md \
  ./audit_result.md
```

The audit generates `audit_result.md` with individual PASS/FAIL checks, category scores, and an overall result.

The project uses an 80% passing threshold.

A passing audit score does not guarantee production readiness. Findings must be reviewed individually.

### Audit Frequency

Run the audit:

- After Dockerfile or Compose changes.
- After SSH or PAM configuration changes.
- After security updates.
- Before deployment.
- During periodic maintenance.

## 5. Maintenance Guidelines

### Security Updates

Rebuild the container image with updated base image layers:

```bash
docker compose build --pull
docker compose up -d
```

### Log Monitoring

```bash
docker compose logs --tail=100
```

Review logs for service failures, unexpected restarts, and suspicious activity.

### Vulnerability Management

- Monitor Debian, Nginx, OpenSSH, and Docker security advisories.
- Apply relevant security updates.
- Review SUID/SGID findings.
- Investigate failed audit checks.
- Remove unnecessary software and privileges.

### Configuration Management

- Track configuration changes with Git.
- Review changes before deployment.
- Never commit passwords, private keys, or tokens.
- Keep security configuration files protected.
- Document exceptions to security policies.

### Backup and Recovery

- Back up important configuration and persistent data.
- Protect SSH keys and backups.
- Keep known-good image versions for rollback.
- Test recovery procedures.

### Future Improvements

- Resolve the conflict between non-root execution and service startup requirements.
- Validate SSH public-key authentication.
- Test PAM account lockout behavior.
- Re-run the audit after security changes.
- Improve foreground service management.

## Conclusion

NovaTech Hardened Shield demonstrates defense-in-depth security through system hardening, identity controls, SSH restrictions, Docker runtime protections, and automated auditing.

Further integration testing and remediation are required before production deployment.