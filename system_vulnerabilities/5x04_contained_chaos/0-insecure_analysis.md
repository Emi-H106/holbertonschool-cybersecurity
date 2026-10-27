# DevStream — Insecure Dockerfile Security Analysis

## Introduction

This document analyzes the insecure Dockerfile provided by DevStream. It identifies security weaknesses, explains their risks, describes how attackers could exploit them, and recommends improvements.

## 1. Unpinned Base Image

**Problem:** The Dockerfile uses `FROM ubuntu:latest` without specifying a fixed version.

**Why it is dangerous:** The `latest` tag can change over time, making builds unpredictable and potentially introducing new vulnerabilities or compatibility issues.

**Possible exploitation:** An attacker could take advantage of vulnerabilities introduced through an unexpectedly updated or outdated base image.

**Remediation:** Use a specific, maintained image version, preferably pinned by digest.

## 2. Unnecessarily Large Base Image

**Problem:** The application uses a full Ubuntu image instead of a minimal Python runtime image.

**Why it is dangerous:** Additional packages increase the attack surface and may introduce unnecessary vulnerabilities.

**Possible exploitation:** An attacker could exploit a vulnerable package included in the image.

**Remediation:** Use an official minimal image such as `python:3.12-slim`, with an appropriately maintained version.

## 3. Unnecessary System Tools

**Problem:** The Dockerfile installs tools such as `curl`, `wget`, `vim`, `net-tools`, `gcc`, and `make`.

**Why it is dangerous:** These tools are not necessarily required at runtime and provide additional functionality that attackers could misuse.

**Possible exploitation:** An attacker who compromises the application could use these tools to download malicious files, inspect the network, or compile additional programs.

**Remediation:** Install only necessary runtime packages and use multi-stage builds to exclude build tools from the final image.

## 4. Unnecessary Sudo Installation

**Problem:** The Dockerfile installs `sudo` even though the application does not require it.

**Why it is dangerous:** Sudo adds unnecessary privileged functionality and increases the attack surface.

**Possible exploitation:** An attacker could abuse insecure sudo configurations or vulnerabilities to elevate privileges.

**Remediation:** Remove `sudo` from the production image.

## 5. Hardcoded Root Password

**Problem:** The Dockerfile sets a root password using:

`RUN echo 'root:devstream123' | chpasswd`

**Why it is dangerous:** The password is embedded in the Dockerfile and may be exposed through image history or build metadata.

**Possible exploitation:** If password-based root authentication is available, an attacker who discovers the password could attempt to authenticate as root.

**Remediation:** Never hardcode passwords in Dockerfiles. Avoid configuring root passwords in application containers.

## 6. Hardcoded Database Credentials

**Problem:** The Dockerfile stores database credentials using `ENV`, including a production database password.

**Why it is dangerous:** Environment variables defined in Dockerfiles are stored in image metadata and may be exposed to anyone with access to the image.

**Possible exploitation:** An attacker could extract the credentials and attempt to access the production database.

**Remediation:** Use a dedicated secrets management solution and provide secrets securely at runtime. Rotate exposed credentials.

## 7. Excessive Database Privileges

**Problem:** The application connects to the database using the `admin` account.

**Why it is dangerous:** Administrative accounts may have permissions beyond those required by the application.

**Possible exploitation:** If the application or its credentials are compromised, an attacker could potentially read, modify, or delete sensitive database records.

**Remediation:** Create a dedicated database account with only the minimum required permissions.

## 8. Unrestricted Application File Copy

**Problem:** The Dockerfile uses `COPY . /app`, copying the entire build context into the image.

**Why it is dangerous:** Sensitive files such as `.env`, private keys, configuration files, and Git metadata may accidentally be included.

**Possible exploitation:** An attacker with access to the image could extract confidential information from copied files.

**Remediation:** Use a `.dockerignore` file and copy only the necessary application files.

## 9. Insecure Dependency Management

**Problem:** Python dependencies are installed using `pip3 install -r requirements.txt` without evidence of version pinning, integrity verification, or vulnerability scanning.

**Why it is dangerous:** Dependencies may contain known vulnerabilities or introduce unexpected changes during builds.

**Possible exploitation:** An attacker could exploit vulnerable packages or compromise an upstream dependency.

**Remediation:** Pin dependency versions, verify package integrity when appropriate, and scan dependencies using tools such as Trivy or pip-audit.

## 10. Application Runs as Root

**Problem:** The Dockerfile does not define a `USER` instruction, so the application runs as root by default.

**Why it is dangerous:** A compromised application would execute with root privileges inside the container, increasing the impact of an attack.

**Possible exploitation:** An attacker could modify protected files inside the container and potentially exploit dangerous mounts or container escape vulnerabilities.

**Remediation:** Create a dedicated non-root user and configure the Dockerfile with the `USER` instruction.

## 11. Insufficient Network Exposure Controls

**Problem:** The Dockerfile declares `EXPOSE 5000` but does not document any network access restrictions.

**Why it is dangerous:** Although `EXPOSE` does not publish a port automatically, insecure runtime port publishing could expose the application to unauthorized users.

**Possible exploitation:** If port 5000 is published publicly, an attacker could access vulnerable application endpoints remotely.

**Remediation:** Restrict published ports, bind to appropriate interfaces, and apply network access controls.

## 12. Missing Runtime Security Controls

**Problem:** The provided configuration does not specify runtime protections such as capability restrictions, read-only filesystems, resource limits, or privilege escalation prevention.

**Why it is dangerous:** Without appropriate runtime controls, a compromised container may have unnecessary privileges or consume excessive host resources.

**Possible exploitation:** An attacker could attempt privilege escalation, modify writable files, or exhaust CPU and memory resources.

**Remediation:** Apply runtime security controls, including:

- `--cap-drop=ALL`
- `--security-opt=no-new-privileges:true`
- `--read-only`
- `--memory=256m`
- `--cpus=1`

These options should be tested and adjusted according to application requirements.

## Conclusion

DevStream's Dockerfile contains multiple security weaknesses, including hardcoded credentials, unnecessary packages, excessive privileges, and insufficient security controls.

The most critical risks are running the application as root, exposing production database credentials, and using an administrative database account.

To improve security, DevStream should adopt minimal and maintained base images, remove unnecessary packages, use non-root users, manage secrets securely, and implement runtime security restrictions.

These improvements follow the principle of least privilege and reduce the container's attack surface.