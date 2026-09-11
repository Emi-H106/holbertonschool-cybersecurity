# LogiCorp Security Design Defense

## Challenge 1: Risk Acceptance

### Business Constraint

FTP is insecure because it sends data without encryption.

However, the Finance team still needs the legacy FTP service for its current business operations. Replacing it immediately could interrupt production.

For this reason, FTP was kept temporarily.

### Risk Mitigation

Several controls were added to reduce the risk:

- FTP is not accessible directly from the Internet.
- Finance users access FTP through the WireGuard VPN.
- Only the Finance VPN client is allowed to access FTP.
- Anonymous FTP access is disabled.
- Firewall rules block unauthorized access.

These controls reduce the exposure while keeping the required service available.

### Residual Risk

FTP is still an insecure legacy protocol.

Even with network restrictions and VPN protection, the risk is not completely removed. The current solution reduces the risk but does not eliminate it.

### Phase 2 Recommendation

The FTP service should be replaced with SFTP in Phase 2.

After the migration, the legacy FTP service can be disabled and removed.


## Challenge 2: Firewall Strategy

### Zone Definitions

The network is divided into different security zones:

- Guest Zone
- Office LAN
- Finance Zone
- DMZ
- Critical Zone
- VPN Zone

The Critical Zone contains the database and has the highest level of protection.

The Guest Zone is considered untrusted and should only have access to the Internet.

### Traffic Restrictions

The firewall uses a Default Deny policy.

Only required traffic is allowed.

Examples:

- Guest users can access the Internet but cannot access internal systems.
- Remote administrators can use SSH only through the WireGuard VPN.
- Finance users can access FTP through the VPN.
- The database only accepts authorized traffic.
- Other traffic is blocked by default.

### Preventing Lateral Movement

The previous ransomware attack succeeded because the network was flat.

A compromised device on the Guest WiFi could move to other internal systems and reach the critical database.

With segmentation, the Guest Zone cannot communicate directly with the Finance, DMZ, Office, or Critical zones.

This blocks the previous attack path:

Guest WiFi -> Internal Network -> Critical Database

### Defense in Depth

The design does not depend on only one security control.

It combines:

- Network segmentation
- Default Deny firewall rules
- WireGuard VPN
- SSH key authentication
- Disabled root SSH login
- Restricted FTP access
- Least privilege access

If one security control fails, other controls still help protect the system.


## Challenge 3: Resilience

### Current Scope

The LogiCorp Gateway is still a Single Point of Failure.

Gateway redundancy was outside the scope of this project, so the current implementation focuses on improving security without changing the availability architecture.

### Current Risk

If the Gateway fails, services that depend on it may become unavailable.

This can affect VPN access, firewall routing, and access between network zones.

This availability risk remains after the current security improvements.

### Phase 2 Recommendation

A future phase should introduce High Availability.

A possible solution is to deploy a second Gateway with:

- Redundant firewall configuration
- Redundant VPN service
- Configuration synchronization
- Automatic failover
- Health monitoring

If the primary Gateway fails, the secondary Gateway could continue providing the required network services.

### Cost-Benefit Analysis

High Availability improves resilience but also increases cost and complexity.

It requires additional infrastructure, configuration, monitoring, testing, and maintenance.

For the current phase, the priority was to reduce the immediate security risks that caused the previous breach.

High Availability should be evaluated in Phase 2 based on LogiCorp's availability requirements, budget, and business impact.