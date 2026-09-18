# Access Control Policy

## 1. Objective

Replace the shared SSH key with individual accounts and apply least
privilege while allowing employees to continue their work.

## 2. Authentication

| Item | Rule |
|---|---|
| Accounts | Each employee must use an individual account. Shared accounts are prohibited. |
| SSH keys | Use individual SSH keys. Never share private keys. |
| SSH login | Use public-key authentication. Disable password authentication and direct root login. |
| Admin panel and VPN | Require MFA. Prohibit weak passwords or PINs, such as birth years, on the admin panel. |
| Offboarding | Disable accounts and access rights, remove authorized SSH keys, and terminate active sessions. |

Apply these SSH settings:

    PubkeyAuthentication yes
    PasswordAuthentication no
    KbdInteractiveAuthentication no
    PermitRootLogin no
    AllowGroups ssh_users

Create individual accounts, register their public keys, and add approved
users to ssh_users. Test the new connections before removing the public
key matching nexus_master.pem from all target servers.

## 3. Authorization

Use Linux groups to assign permissions by role.

| Group | Allowed Actions |
|---|---|
| developers | Work in development and staging; read approved production application logs. No production sudo access. |
| operators | Read approved application logs; check and restart only the specified application service. |
| secadmins | Approved administrators may use sudo to manage systems and security settings. |
| auditors | Read approved audit logs and reports. No modification or deletion. |

- Use group permissions or ACLs to restrict file access.
- Limit operators' sudo access to the exact commands and arguments
  needed to manage the specified service.
- Do not allow operators to modify that service's executable files
  or configuration.
- Grant emergency permissions temporarily to an approved individual
  account and log its actions.

## 4. Network

| Service | Allowed Sources |
|---|---|
| SSH — TCP 22 | Management VPN subnet only. |
| PostgreSQL — TCP 5432 | Specified application servers and database administration host only. |
| HTTPS — TCP 443 | Internet access to the public web server. |
| HTTP — TCP 80 | Allow only when needed, such as for HTTPS redirection. |
| Other incoming traffic | Deny by default. |

- Allow loopback, established and related connections, and necessary
  ICMP traffic.
- Apply database source restrictions in both the firewall and
  PostgreSQL's pg_hba.conf.
- Apply equivalent restrictions to IPv6 when enabled.
- Block guest Wi-Fi access to internal servers.
- Confirm that approved connection paths work before blocking
  existing access.

## 5. Implementation and Verification

Before implementation, define the allowed IP addresses and subnets,
the exact service name, and the paths of readable logs.

After applying the policy, verify that:

- Individual SSH keys work and the shared key does not.
- Each role can perform only its approved actions.
- Unauthorized database connections are blocked.
- Legitimate business access and the public web service still work.