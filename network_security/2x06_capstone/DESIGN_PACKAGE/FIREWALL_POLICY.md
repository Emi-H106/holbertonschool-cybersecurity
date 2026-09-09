# LogiCorp Firewall Policy

## Default Policies

| Chain | Policy |
|---|---|
| INPUT | DROP |
| FORWARD | DROP |
| OUTPUT | ACCEPT |

The firewall uses Default Deny. Only necessary traffic is allowed.

## Firewall Rules

| Source | Destination | Service | Action | Reason |
|---|---|---|---|---|
| WAN | Gateway | WireGuard UDP 51820 | ALLOW | Allow VPN connection |
| WAN | Gateway | SSH TCP 22 | DENY | SSH must use VPN |
| WAN | FTP Server | FTP TCP 21 | DENY | FTP must not be public |
| Guest | Internet | Required traffic | ALLOW | Internet access |
| Guest | Internal Zones | Any | DENY | Prevent lateral movement |
| Office | Internet | Required traffic | ALLOW | Internet access |
| Office | Critical DB | TCP 3306 | DENY | Protect the database |
| Finance | Internet | Required traffic | ALLOW | Internet access |
| Finance | FTP Server | TCP 21 | ALLOW | Finance needs FTP |
| Finance | Critical DB | TCP 3306 | DENY | Protect the database |
| DMZ | Internal Zones | Any | DENY | Isolate the DMZ |
| VPN Admin | Gateway | SSH TCP 22 | ALLOW | Remote administration |
| VPN Admin | Critical DB | TCP 3306 | ALLOW if needed | Admin access |
| Any | Any | Other traffic | DENY | Default Deny |

## General Rules

Allow loopback traffic:

`iifname "lo" accept`

Allow established and related connections:

`ct state established,related accept`

These rules are placed first to allow local traffic and existing connections.

## Rule Order

1. Loopback traffic
2. Established and related connections
3. WireGuard VPN
4. VPN administration
5. Finance FTP
6. Required Internet traffic
7. Deny all other traffic

The firewall only allows necessary traffic. All other traffic is blocked.