# DevStream — Container Security Guidelines

**Document Owner:** Security Engineering Team
**Version:** 1.0
**Status:** Proposed Policy
**Scope:** All DevStream Docker images and containers

## 1. Dockerfile Rules

### Required Practices

- Use trusted, minimal base images.
- Pin base image versions and use verified digests for production.
- Run applications as a dedicated non-root user.
- Use multi-stage builds when compilation tools are needed.
- Install only necessary packages and dependencies.
- Use `.dockerignore` to exclude secrets, temporary files, and unnecessary content.
- Add appropriate LABEL metadata.
- Configure a meaningful HEALTHCHECK for long-running services.
- Use COPY instead of ADD unless ADD-specific functionality is required.
- Keep development tools out of production runtime images.

### Prohibited Practices

- Do not use privileged containers without an approved exception.
- Do not hardcode passwords, API keys, or tokens.
- Do not store secrets in ARG, ENV, or Docker image layers.
- Do not use unverified public images.
- Do not install unnecessary compilers or administrative tools.
- Do not run applications as root unless explicitly approved.

## 2. Base Image Policy

### Approved Base Images

- Official Python slim images, such as `python:3.11-slim`.
- Official Alpine images when application compatibility is verified.
- Verified distroless images for production workloads.
- Other approved, maintained images from trusted registries.

### Update Requirements

- Pin image versions and verified digests in production.
- Review base image security updates at least monthly.
- Rebuild images when security patches become available.
- Prioritize critical vulnerabilities for immediate assessment.
- Replace unsupported or end-of-life images.
- Scan base images and dependencies before deployment.

The `latest` tag must not be used for production deployments.

## 3. Secret Management

Secrets include passwords, API keys, tokens, certificates, and private keys.

### Required Practices

- Use an approved secrets manager or orchestrator secret mechanism.
- Inject secrets securely at runtime.
- Restrict access using least-privilege permissions.
- Rotate secrets regularly and after suspected compromise.
- Never commit secrets to Git repositories.
- Use secret scanning in CI/CD pipelines.
- Keep secrets out of logs and diagnostic output.

### Prohibited Practices

- Do not embed secrets in Dockerfiles.
- Do not store secrets in Docker images.
- Do not pass sensitive values through Docker build arguments.
- Do not expose secrets through command-line arguments.
- Do not include real production credentials in development environments.

If a secret is exposed, revoke or rotate it immediately and report the incident.

## 4. Runtime Requirements

Production containers must use the following security controls unless an exception is approved.

### Identity and Privileges

- Run as a non-root user.
- Drop all unnecessary Linux capabilities.
- Enable `no-new-privileges`.
- Never use `--privileged` by default.
- Do not mount the Docker socket into application containers.
- Do not share host PID, IPC, or network namespaces unless approved.

### Filesystem Security

- Use a read-only root filesystem whenever possible.
- Use restricted volumes or tmpfs for required writable paths.
- Apply `nosuid` and `nodev` to temporary mounts where appropriate.
- Do not mount sensitive host directories.

### Resource Limits

- Configure memory limits.
- Configure CPU limits.
- Configure PID limits.
- Avoid unrestricted resource consumption.

### Additional Controls

- Apply the default or a stricter approved seccomp profile.
- Use AppArmor or SELinux policies where supported.
- Restrict network access to required services.
- Publish only necessary ports.
- Configure application-specific health checks.

### Example Secure Runtime

```bash
docker run -d \
  --name secure-app \
  --user=1000:1000 \
  --cap-drop=ALL \
  --security-opt=no-new-privileges:true \
  --read-only \
  --tmpfs /tmp:rw,nosuid,nodev,size=64m,mode=1777 \
  --memory=256m \
  --memory-swap=256m \
  --cpus=0.5 \
  --pids-limit=50 \
  secure-python-dev:v1
```

Resource limits must be adjusted to application requirements.

## 5. Audit Requirements

### Audit Schedule

- Before every production deployment.
- After significant Dockerfile or configuration changes.
- After critical vulnerability disclosures affecting deployed components.
- At least monthly for production container environments.
- After security incidents involving containers.

### Required Audit Activities

1. Run Docker Bench for Security to assess Docker host and runtime configuration.
2. Scan container images for known vulnerabilities.
3. Inspect container configuration using `docker inspect`.
4. Verify non-root execution and Linux capability restrictions.
5. Verify read-only filesystem and resource limits.
6. Check secrets handling and image metadata.
7. Review health checks and network exposure.
8. Record findings and remediation actions.

### Reporting

Audit reports must include:

- Audit date and environment.
- Image name and immutable digest.
- Security findings and severity.
- Remediation owner and deadline.
- Accepted exceptions and their expiration dates.
- Final approval status.

High-risk findings must be resolved or formally accepted before deployment.

Docker Bench results must be interpreted in context. Host-level checks must not be presented as image-specific results.

## 6. Exception Process

Exceptions are allowed only when a documented business or technical requirement prevents compliance.

### Request Procedure

1. Submit an exception request to the Security Engineering Team.
2. Identify the specific security rule.
3. Explain the technical or business justification.
4. Describe the affected images, containers, and environments.
5. Assess the security risks.
6. Propose compensating security controls.
7. Specify an expiration date and remediation plan.
8. Obtain approval before deploying the exception.

### Approval and Review

- The Security Engineering Team reviews the request.
- The responsible service owner must acknowledge the risk.
- High-risk exceptions require additional management approval.
- Approved exceptions must be recorded in an exception register.
- Exceptions must be reviewed periodically and must not remain permanent without renewed approval.
- Expired exceptions must be remediated or formally renewed.

### Emergency Exceptions

Emergency exceptions require documented authorization, temporary compensating controls, and a post-incident review.

## Conclusion

These guidelines establish consistent security requirements for DevStream's containerized development and production environments.

All developers are responsible for following these rules, while the Security Engineering Team oversees audits, exceptions, and continuous improvement.

Container security is a shared responsibility and must be maintained throughout the software development lifecycle.
