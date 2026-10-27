
# Secure Python Development Environment — Design Document

## 1. Base Image Selection

The development environment will use `python:3.11-slim`.

Reasons:
- Smaller attack surface than a full Ubuntu image.
- Includes Python and pip.
- Compatible with common Python development tools.
- Reduces unnecessary packages and image size.
- Uses a specific Python minor version instead of `latest`.

For production, the image should be pinned to a verified digest and updated regularly.

## 2. Included Development Tools

The environment will include:

- **Python 3.11** — application development.
- **pip** — Python package installation.
- **pytest** — automated unit testing.
- **ruff** — linting and code formatting.
- **bandit** — Python security analysis.
- **pip-audit** — dependency vulnerability scanning.

Development dependencies will be maintained in a dedicated requirements file with pinned versions.

Unnecessary system packages, compilers, and debugging tools will not be included by default.

## 3. Non-Root User Configuration

The container will run as a dedicated non-root user.

Configuration:

- Username: `appuser`
- UID: `1000`
- GID: `1000`
- Home directory: `/home/appuser`
- Working directory: `/workspace`

Example Dockerfile:

```dockerfile
RUN groupadd -g 1000 appuser && \
    useradd -m -u 1000 -g appuser appuser

WORKDIR /workspace

USER appuser
```

Running as a non-root user limits the impact of application vulnerabilities.

The user will not have sudo privileges inside the container.

## 4. Volume Strategy

Source code will be mounted from the host using a bind mount.

Example:

```bash
docker run --rm -it \
    --mount type=bind,source="$(pwd)",target=/workspace \
    secure-python-dev:latest
```

Benefits:
- Developers can edit files using VS Code on the host.
- Changes are immediately available inside the container.
- Source code remains on the host when the container is removed.

The development workspace will be writable because developers need to edit files.

Sensitive host directories, Docker sockets, and SSH private keys will not be mounted.

Temporary files will use a dedicated tmpfs mount.

For production, application code will be copied into the image instead of using a writable source-code bind mount.

## 5. Security Hardening Measures

The environment will apply the following security controls:

### Non-Root Execution

Run processes as `appuser` instead of root.

### Linux Capabilities

Remove unnecessary Linux capabilities:

```bash
--cap-drop=ALL
```

### Prevent Privilege Escalation

Enable:

```bash
--security-opt=no-new-privileges:true
```

### Seccomp Protection

Use Docker's default seccomp profile to restrict dangerous system calls.

### Read-Only Root Filesystem

Use:

```bash
--read-only
```

Allow required writable locations through explicitly configured mounts:

```bash
--tmpfs /tmp:rw,nosuid,nodev,size=64m,mode=1777
```

The development workspace remains writable through its bind mount.

### Resource Limits

Apply limits to prevent excessive resource consumption:

```bash
--memory=256m
--memory-swap=256m
--cpus=0.5
--pids-limit=50
```

These limits are initial development defaults and should be adjusted if testing tools require more resources.

### Secret Management

- Never store passwords or API keys in Dockerfiles.
- Never commit secrets to Git.
- Inject development secrets at runtime through an approved secret-management mechanism.
- Avoid exposing secrets through command-line arguments or image layers.

### Network Security

- Do not use privileged mode.
- Do not expose unnecessary ports.
- Bind development ports to localhost when possible.
- Use isolated Docker networks when appropriate.

### Image Security

- Use trusted base images.
- Pin dependencies.
- Scan images and dependencies for vulnerabilities.
- Rebuild images regularly with security updates.

## 6. Developer Experience

Developers will use Docker Desktop with WSL2 and VS Code.

Typical workflow:

1. Clone the project repository.
2. Build the development image.
3. Start the container with the project directory mounted.
4. Edit Python files using VS Code.
5. Run tests and security checks inside the container.
6. Stop the container when development is complete.

Example commands:

```bash
docker build -t secure-python-dev:latest .

docker run --rm -it \
    --name secure-python-dev \
    --user=appuser \
    --cap-drop=ALL \
    --security-opt=no-new-privileges:true \
    --read-only \
    --tmpfs /tmp:rw,nosuid,nodev,size=64m,mode=1777 \
    --mount type=bind,source="$(pwd)",target=/workspace \
    --memory=256m \
    --memory-swap=256m \
    --cpus=0.5 \
    --pids-limit=50 \
    secure-python-dev:latest
```

Development commands:

```bash
pytest
ruff check .
ruff format --check .
bandit -r .
pip-audit
```

The development image will provide a consistent Python environment across different developer machines.

## 7. Security and Usability Trade-Offs

Security controls must not prevent normal development activities.

A writable workspace is required for editing source code, while the container root filesystem can remain read-only.

Some development tools may require additional memory, temporary storage, or permissions.

Any exceptions should be documented and limited to the minimum necessary scope.

## Conclusion

This design combines usability with defense-in-depth security.

The environment uses a lightweight Python image, a non-root user, restricted Linux capabilities, seccomp filtering, a read-only root filesystem, and resource limits.

Developers retain access to essential Python tools while unnecessary privileges and host access are restricted.
