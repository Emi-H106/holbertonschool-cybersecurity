# Access Control Policy

## 1. Objective

Replace the shared SSH key with individual accounts and apply least
privilege while allowing employees, including the Bali remote team,
to continue their work securely.

## 2. Authentication

| Item | Rule |
|---|---|
| Accounts | Each employee must use an individual account. Shared accounts are prohibited. |
| SSH keys | Use individual SSH keys. Never share private keys or post them in Slack. |
| SSH login | Use public-key authentication. Disable password authentication and direct root login. |
| Admin panel and VPN | Require MFA. Prohibit weak passwords or PINs, such as birth years, on the admin panel. |
| Offboarding | Disable accounts and access rights, remove authorized SSH keys, and terminate active sessions. |

Apply these SSH settings:

    PubkeyAuthentication yes
    PasswordAuthentication no
    KbdInteractiveAuthentication no
    PermitRootLogin no
    AllowGroups ssh_users

### Replacing the Shared Key

1. Create individual accounts and register each user's public key.
2. Add approved SSH users to the ssh_users group.
3. Test individual connections and required work tasks.
4. Remove the public key matching nexus_master.pem from all target servers.
5. Confirm that the shared key no longer works.
6. Remove the shared private key from Slack.

Validate SSH configuration before reloading the service.
Keep an existing administrative session open until a new login succeeds.

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
- Validate sudo rules with visudo before applying them.
- Require approval from the security lead for privileged access.
- Grant emergency permissions temporarily to an approved individual
  account and log its actions. Remove permissions when they expire.
- Never restore the shared SSH key as an emergency solution.

## 4. Network

Deny incoming connections unless they are explicitly required.

| Service | Allowed Sources |
|---|---|
| SSH — TCP 22 | Management VPN subnet only. |
| PostgreSQL — TCP 5432 | Specified application servers and the designated database access host only. |
| HTTPS — TCP 443 | Internet access to the public web server. |
| HTTP — TCP 80 | Allow only when needed, such as for HTTPS redirection. |
| Other incoming traffic | Deny by default. |

- Allow loopback, established and related connections, and necessary
  ICMP traffic.
- Apply database source restrictions in host and cloud firewalls
  and in PostgreSQL's pg_hba.conf.
- Require authenticated, encrypted database connections.
- Apply equivalent restrictions to IPv6 when enabled.
- Block guest Wi-Fi access to internal servers.
- Confirm that approved connection paths work before blocking
  existing access.

### Bali Remote Team Access

The database was opened to the internet because the Bali team
experienced VPN performance problems. Fix the remote access path
instead of keeping the database public.

- Investigate VPN latency and routing problems.
- Test a VPN endpoint closer to Bali and measure performance
  to the required services before choosing the endpoint.
- Require individual VPN accounts with MFA.
- Provide a designated database access host, acting as a jump host
  or database proxy, reachable only through the approved VPN.
- Allow approved remote database work through this host.
  VPN membership alone does not grant database permissions.
- Developers should normally use development or staging databases.
  Production database access requires explicit approval and an
  individual database account with only the necessary permissions.
- Test the new access path with the Bali team, then promptly remove
  the rule allowing TCP 5432 from 0.0.0.0/0 and any equivalent
  unrestricted IPv6 rule.
- Keep PostgreSQL private. Do not reopen public database access
  as a workaround for VPN problems.

## 5. Implementation and Verification

Before implementation, define the following values:

| Value | Purpose |
|---|---|
| Management VPN subnet | Source range allowed to access SSH and the database access host. |
| Application server IP addresses | Sources allowed to connect to PostgreSQL. |
| Database access host IP address | Approved host for remote database access. |
| Application service name | Exact service operators may check and restart. |
| Application log paths | Logs developers and operators may read. |
| Audit log paths | Logs and reports auditors may read. |

After applying the policy, verify that:

- Individual SSH keys work and the shared key does not.
- Direct root and password-based SSH logins fail.
- Each role can perform only its approved actions.
- Unauthorized database connections are blocked.
- PostgreSQL cannot be reached directly from the public internet
  over IPv4 or IPv6.
- The Bali team can complete approved work through the VPN and
  database access host with acceptable performance.
- Legitimate business access and the public web service still work.