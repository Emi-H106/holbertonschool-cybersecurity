# NovaTech — Patch Management Incident Response Playbook

**Document Owner:** Security Operations / Infrastructure Team  
**Version:** 1.0  
**Status:** Draft for Approval  
**Scope:** NovaTech Linux servers and patch-related incidents

## 1. Detection Criteria

A patch-related incident is suspected when a system becomes unstable or a service fails during or shortly after a package update.

Common indicators include:

- A critical service such as Apache, MySQL, or SSH fails to start.
- An application returns HTTP 500 errors or becomes unavailable.
- CPU, memory, or disk usage increases unexpectedly after patching.
- A package installation fails or leaves dependencies broken.
- A kernel update causes boot failure or network connectivity problems.
- Monitoring alerts occur shortly after an automatic update.

Check the following logs:

```bash
sudo tail -50 /var/log/apt/history.log
sudo tail -50 /var/log/dpkg.log
sudo tail -50 /var/log/unattended-upgrades/unattended-upgrades.log
```

## 2. Initial Assessment — First 5 Minutes

**Minute 0–1: Confirm the incident**

- Acknowledge the monitoring alert.
- Record the incident start time.
- Identify affected servers and services.

**Minute 1–2: Assess business impact**

- Determine whether the service is completely unavailable or degraded.
- Identify affected users and business operations.
- Classify the incident severity.

**Minute 2–3: Check system status**

```bash
systemctl --failed
uptime
df -h
free -h
```

**Minute 3–4: Check recent updates**

```bash
sudo tail -30 /var/log/apt/history.log
sudo tail -30 /var/log/dpkg.log
```

**Minute 4–5: Escalate and contain**

- Notify the on-call infrastructure engineer.
- Inform the Security Team if a security patch is involved.
- Pause further patch deployments on affected systems when necessary.
- Preserve logs and avoid unnecessary changes.

## 3. Diagnosis Steps

### Step 1 — Identify the affected service

```bash
sudo systemctl status apache2
sudo journalctl -u apache2 --since "1 hour ago"
```

Replace `apache2` with the affected service name.

### Step 2 — Review package changes

```bash
grep ' upgrade ' /var/log/dpkg.log | tail -20
sudo zgrep ' upgrade ' /var/log/dpkg.log* | tail -30
```

Review the package name, previous version, new version, and update timestamp.

### Step 3 — Identify a possible problematic package

Use the Task 20 diagnostic script:

```bash
sudo ./20-identify_bad_update.sh "YYYY-MM-DD HH:MM"
```

Compare update timestamps with the incident start time.

A package updated shortly before an incident is a candidate, not proof of the root cause.

### Step 4 — Verify available package versions

```bash
apt-cache policy <package>
apt-cache madison <package>
```

Check whether an earlier version is available for rollback.

### Step 5 — Preserve evidence

Record:

- Incident timestamp and affected host
- Error messages and monitoring alerts
- Recent package updates
- Relevant application and system logs
- Current package versions

## 4. Rollback Procedure

### Step 1 — Obtain authorization

Notify the incident manager and obtain approval before performing a production rollback, except where an approved emergency procedure permits immediate action.

### Step 2 — Create a recovery point

Create a VM snapshot or verified system backup when possible.

For Multipass environments, use the supported snapshot functionality if available.

A package inventory is not equivalent to a full system snapshot.

### Step 3 — Check rollback feasibility

```bash
apt-cache madison <package>
```

Verify that the previous version is available and assess dependencies and security implications.

### Step 4 — Simulate the downgrade

```bash
sudo apt-get -s install --allow-downgrades <package>=<version>
```

Review any additional package changes before proceeding.

### Step 5 — Execute the rollback

Use the Task 21 script:

```bash
sudo ./21-rollback_package.sh <package> <version>
```

Proceed only after reviewing the simulation and confirming the recovery plan.

If the version is unavailable, restore from a verified backup or snapshot instead of forcing an unsupported downgrade.

### Step 6 — Verify recovery

Check the installed version:

```bash
dpkg-query -W -f='${Version}\n' <package>
```

Check the affected service:

```bash
sudo systemctl status <service>
```

Perform an application health check. For a local HTTP service:

```bash
curl -I http://localhost
```

Confirm that monitoring alerts have cleared and users can access the service.

### Step 7 — Prevent re-upgrade

If the previous version must remain temporarily installed, apply a documented package hold:

```bash
sudo ./22-hold_package.sh <package> "Incident rollback pending upstream fix"
```

Review holds regularly using:

```bash
sudo ./23-manage_holds.sh list
```

A hold also blocks security updates and must be reviewed promptly.

### Step 8 — Close or escalate

If service recovery fails, escalate to the incident manager and use the approved backup restoration or disaster recovery procedure.

Document all changes and recovery results.

## 5. Communication Plan

| Time | Recipient | Information |
|---|---|---|
| Immediately | On-call infrastructure engineer | Alert, affected host, symptoms |
| Within 5 minutes | Incident manager / Security Team | Severity, business impact, suspected patch |
| Within 15 minutes | Application owner / Service owner | Service status and recovery plan |
| Every 30 minutes during major incidents | Incident stakeholders | Progress, blockers, next update |
| After recovery | CISO, management, affected teams | Resolution, impact, remaining risks |
| Within 48 hours | Security and Infrastructure Teams | Initial post-incident review |

Communication must include:

- Incident ID and start time
- Affected systems and services
- Confirmed facts versus suspected causes
- Actions taken and current status
- Next update time

Avoid sharing unverified root-cause claims.

## 6. Post-Incident Review

Complete a post-incident review within five business days after service restoration.

### Lessons Learned Template

**Incident ID:**  
**Date and Time:**  
**Incident Owner:**  
**Affected Systems:**  
**Severity:**  
**Duration:**  

**1. Incident Summary**  
Describe what happened and which services were affected.

**2. Business Impact**  
Document downtime, affected users, and operational impact.

**3. Timeline**  
Record detection, escalation, diagnosis, rollback, and recovery times.

**4. Root Cause**  
Identify the package, version, configuration, or dependency responsible. Clearly distinguish confirmed evidence from assumptions.

**5. Recovery Actions**  
Describe the rollback, restoration, and verification steps performed.

**6. What Worked Well**  
Identify effective monitoring, communication, and recovery actions.

**7. What Could Be Improved**  
Describe gaps in testing, patch approval, monitoring, or backup readiness.

**8. Corrective Actions**

| Action | Owner | Deadline | Status |
|---|---|---|---|
| Improve pre-deployment testing | Infrastructure Team | TBD | Open |
| Review package blacklist and holds | Security Team | TBD | Open |
| Verify backup restoration procedure | Infrastructure Team | TBD | Open |

**9. Final Approval**  
Incident Manager:  
Review Date:  

## 7. Incident Closure Criteria

An incident may be closed when:

- Affected services are operational.
- Application health checks pass.
- Monitoring confirms system stability.
- Temporary package holds are documented.
- Incident evidence and recovery actions are recorded.
- Remaining risks and follow-up actions have assigned owners.

**End of Playbook**
