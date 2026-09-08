# LogiCorp Gateway - Technical Audit Report

## 1. System Information

The basic system information was collected with:

```bash
hostname
cat /etc/os-release
uname -r
uptime
```

The results are:

| Item | Result |
|---|---|
| Hostname | `ip-10-42-126-208.ec2.internal` |
| Operating System | `Ubuntu 22.04.5 LTS (Jammy Jellyfish)` |
| Kernel Version | `6.1.177` |
| Uptime | About 3 hours 46 minutes |

The LogiCorp Gateway is running Ubuntu 22.04.5 LTS with kernel version `6.1.177`.


---

## 2. Network Topology

The network interfaces, IP addresses, routes and neighbors were inspected with:

```bash
ip addr
ip route
ip neigh
```

### 2.1 Network Interfaces

The following interfaces are present:

| Interface | IPv4 Address | Status |
|---|---|---|
| `lo` | `127.0.0.1/8` | UP |
| `eth0` | `169.254.172.2/22` | UP |
| `eth1` | `10.42.126.208/16` | UP |

The main network interface is `eth1` with the IP address:

```text
10.42.126.208/16
```

IPv6 link-local addresses are also present on `eth0` and `eth1`.


### 2.2 Routing Table

The routing table contains:

```text
default via 10.42.0.1 dev eth1
10.42.0.0/16 dev eth1 proto kernel scope link src 10.42.126.208
blackhole 169.254.169.254
169.254.170.2 via 169.254.172.1 dev eth0
169.254.172.1 dev eth0 scope link
```

The default gateway is:

```text
10.42.0.1
```

and it uses the `eth1` interface.


### 2.3 Neighbor Table

The following neighbor entry is present:

| IP Address | Interface | MAC Address | State |
|---|---|---|---|
| `10.42.0.1` | `eth1` | `16:ca:fb:da:4b:d3` | REACHABLE |

This IP address is also the default gateway.


### 2.4 LogiCorp Network Configuration

The LogiCorp network configuration is stored in:

```text
/etc/logicorp/network.conf
```

The file contains:

```text
NETWORK_MODE=FLAT
```

This shows that the LogiCorp network is configured as a flat network.

This matches the client documentation. Guest, Finance, internal systems and critical systems do not have enough network separation.


### 2.5 Database Configuration

The database configuration is stored in:

```text
/etc/logicorp/db.conf
```

The file contains:

```text
DB_HOST=192.168.1.50
DB_PORT=3306
```

The configured database address is:

```text
192.168.1.50:3306
```

No specific route for `192.168.1.0/24` appears in the routing table.

The database address is present in the configuration, but this does not confirm if the database is reachable or correctly isolated from the other networks.


---

## 3. Attack Surface

The listening TCP and UDP ports were inspected with:

```bash
ss -tulpn
```

The following TCP ports are listening:

| Port | Service / Process | Description |
|---:|---|---|
| 21/TCP | `vsftpd` | FTP service |
| 22/TCP | `sshd` | SSH service |
| 3000/TCP | OpenVSCode Server / Node.js | Lab-related service |
| 3001/TCP | `ttyd` | Lab-related service |

No listening UDP ports were identified during the audit.


### 3.1 FTP Service

The FTP configuration is stored in:

```text
/etc/vsftpd.conf
```

The important settings are:

```text
local_enable=YES
write_enable=YES
ssl_enable=NO
anonymous_enable=YES
```

An earlier line in the file also contains:

```text
anonymous_enable=NO
```

but later in the file it is changed to:

```text
anonymous_enable=YES
```

This means anonymous FTP is enabled in the final configuration.

The main security problems are:

- FTP is running on TCP port 21.
- Local users can use FTP.
- Write access is enabled.
- Anonymous FTP is enabled.
- SSL/TLS is disabled.

The client documentation says that Finance still needs this legacy FTP service.

For this reason, the service should not simply be removed. Access should be restricted and protected with network security controls.


### 3.2 Other Network Services

Services are also listening on:

```text
TCP 3000
TCP 3001
```

The related processes are OpenVSCode Server and `ttyd`.

The startup script `/etc/run.sh` also starts these services.

These services appear to be part of the Holberton lab environment, so they are not considered LogiCorp security problems.

Passwords and access tokens related to these services are not included in this report.


### 3.3 Telnet

Some Telnet-related files and a `telnetd` account are present on the system.

TCP port 23 was checked with:

```bash
ss -tlnp | grep ':23'
```

No listener was identified on TCP port 23.

Telnet-related processes were also checked with:

```bash
ps aux | grep -E '[t]elnetd|[i]netd|[x]inetd'
```

No active `telnetd`, `inetd` or `xinetd` process was identified.

Telnet-related files are present, but there is no evidence that the Telnet service is currently running.


---

## 4. Security Controls

### 4.1 Firewall

The nftables ruleset was inspected with:

```bash
nft list ruleset
```

The command returned:

```text
Operation not permitted (you must be root)
```

The complete active nftables rules could not be viewed with the available permissions.

The legacy `iptables` command was also tested:

```bash
iptables -L -n
```

but the command is not installed:

```text
iptables: command not found
```

The current firewall rules could not be fully confirmed with these commands.


### 4.2 Firewall Initialization

The startup script:

```text
/etc/run.sh
```

contains:

```bash
nft flush ruleset 2>/dev/null
```

This command removes the nftables rules during startup.

This is a security problem because LogiCorp should use a Default Deny firewall policy.

However, the current nftables rules could not be checked without root permissions.

For this reason, it is not possible to say that no firewall rules are active now. Other rules may have been added after startup.


### 4.3 AppArmor

The command:

```bash
aa-status
```

is not available.

The path:

```text
/sys/module/apparmor/parameters/enabled
```

also does not exist.

No evidence of active AppArmor was identified with these checks.


### 4.4 SELinux

The command:

```bash
getenforce
```

is not available.

The directory:

```text
/sys/fs/selinux
```

exists, but it is empty.

The command:

```bash
mount | grep selinux
```

does not return any result.

No evidence of active SELinux enforcement was identified with these checks.


### 4.5 Fail2ban

A LogiCorp Fail2ban action file exists at:

```text
/etc/fail2ban/action.d/logicorp-flag.conf
```

However, the presence of this file does not confirm that Fail2ban is currently running.

Active Fail2ban protection could not be confirmed from this file alone.


---

## 5. User Accounts

### 5.1 Local Users

The local accounts were reviewed in:

```text
/etc/passwd
```

The accounts with an interactive shell are:

| User | UID | Shell |
|---|---:|---|
| `root` | 0 | `/bin/bash` |
| `student` | 1000 | `/bin/bash` |

Other service accounts, such as `ftp` and `telnetd`, use:

```text
/usr/sbin/nologin
```

The `student` account is used for access to the Holberton lab environment, so it is not considered a LogiCorp security problem.


### 5.2 Sudo Configuration

The sudo configuration contains an additional file:

```text
/etc/sudoers.d/debug
```

This file can only be read by root.

Its content could not be viewed with the available permissions, so its purpose could not be confirmed.


### 5.3 SSH Keys

SSH key authentication is configured on the system.

The `authorized_keys` file has these permissions:

```text
600
```

This means that only the owner can read and modify the file.

The SSH configuration also contains:

```text
PubkeyAuthentication yes
```

SSH public key authentication is enabled.


### 5.4 SSH Configuration

The SSH configuration is stored in:

```text
/etc/ssh/sshd_config
```

The important settings are:

```text
PermitRootLogin yes
PubkeyAuthentication yes
PasswordAuthentication yes
KbdInteractiveAuthentication no
UsePAM yes
X11Forwarding yes
```

SSH key authentication is enabled.

Password authentication is also enabled. Using only SSH keys would be safer if password authentication is not required.

The configuration also contains:

```text
PermitRootLogin yes
```

This does not follow the LogiCorp security policy about root login.

X11 forwarding is also enabled. It should be disabled if it is not needed.


### 5.5 Root Login Policy

The LogiCorp security policy is stored in:

```text
/etc/logicorp/security.policy
```

It says:

```text
root login should never happen
```

The SSH configuration contains:

```text
PermitRootLogin yes
```

The security policy and the SSH configuration do not match.

The SSH configuration should be changed to:

```text
PermitRootLogin no
```

Password authentication should also be reviewed and disabled if it is not required.


### 5.6 Sensitive Backup

A backup file exists at:

```text
/opt/logicorp/backups/backup.sql
```

Its permissions are:

```text
-rw-r--r-- root root
```

This means other users can read the file.

The file contains a password stored in plaintext.

The real password is not included in this report.

This is a security problem because sensitive credentials should not be stored in plaintext, especially in a file that other users can read.

The file permissions should be more restrictive, and the exposed credential should be changed if it is still in use.


---

## 6. Running Services

The running services were first checked with:

```bash
systemctl --type=service --state=running
```

The command returned:

```text
System has not been booted with systemd as init system (PID 1). Can't operate.
Failed to connect to bus: Host is down
```

This environment does not use systemd as PID 1, so `systemctl` cannot be used normally.

Running processes were checked with:

```bash
ps -eo user,pid,ppid,args --cols 200
```

Listening network services were checked with:

```bash
ss -tulpn
```

The following services are active:

| Service / Process | Port | User | Description |
|---|---:|---|---|
| `vsftpd` | 21/TCP | root | FTP server |
| `sshd` | 22/TCP | root | SSH server |
| OpenVSCode Server / Node.js | 3000/TCP | root | Lab-related service |
| `ttyd` | 3001/TCP | root | Lab-related service |
| `cron` | N/A | root | Scheduled task service |

`cron` does not listen on a network port, so its port is marked as `N/A`.

The startup script `/etc/run.sh` contains:

```bash
service vsftpd start
service cron start
service ssh restart
```

This shows that FTP, cron and SSH are started during system initialization.


---

## 7. Scheduled Tasks

### 7.1 Cron Job

A LogiCorp cron job is configured in:

```text
/etc/cron.d/logicorp
```

It contains:

```text
* * * * * root /usr/bin/curl http://192.168.1.200/ping
```

This command runs every minute as root.

It sends an HTTP request to:

```text
192.168.1.200
```

No port number is specified in the URL, so HTTP normally uses TCP port 80.

The same `curl` command was also visible in the running processes. This confirms that the cron job is being executed.

This task is not mentioned in the client documentation.

The purpose of `192.168.1.200` is unknown. It is also different from the configured database address `192.168.1.50`.

For this reason, this cron job needs more investigation.


### 7.2 Systemd Timers

Systemd timers could not be checked normally because systemd is not running as PID 1.

For example:

```bash
systemctl list-timers
```

cannot be used normally in this environment.

The presence of active systemd timers could not be confirmed during this audit.


---

## 8. Differences Between Documentation and Reality

The client documentation was compared with the system configuration and current state.

| Documentation / Expected State | Audit Result | Status |
|---|---|---|
| Network is flat | `NETWORK_MODE=FLAT` | Confirmed |
| Critical database exists | `192.168.1.50:3306` is present in the configuration | Confirmed in configuration |
| Critical database should be isolated | Flat network configuration is present | Needs better segmentation |
| Finance needs legacy FTP | `vsftpd` is running on TCP 21 | Confirmed |
| Finance uses cleartext FTP | `ssl_enable=NO` | Confirmed |
| Anonymous FTP was not documented | `anonymous_enable=YES` | Additional problem |
| Remote SSH access must remain available | `sshd` is listening on TCP 22 | Confirmed |
| Root login should not be allowed | `PermitRootLogin yes` is configured | Does not follow policy |
| SSH key authentication is available | `PubkeyAuthentication yes` and `authorized_keys` are present | Confirmed |
| Gateway should use firewall controls | `/etc/run.sh` flushes nftables rules at startup | Security problem |
| Root cron communication was not documented | Cron contacts `192.168.1.200` every minute | Undocumented activity |
| Sensitive backup was not documented | A readable backup contains a plaintext password | Additional security problem |
| Telnet-related files exist | No TCP 23 listener or active Telnet process | Telnet is not currently running |


---

## Conclusion

The audit confirmed several security problems described in the LogiCorp documentation. Some additional problems were also identified.

The main problems are:

- The network is configured as a flat network. This can make lateral movement easier.
- The database is configured at `192.168.1.50:3306`, but its isolation could not be confirmed.
- The startup script removes the nftables rules.
- FTP is running without TLS encryption.
- Anonymous FTP is enabled.
- SSH password authentication is enabled.
- The SSH configuration contains `PermitRootLogin yes`, but the LogiCorp security policy says root login should not happen.
- An undocumented cron job runs every minute as root.
- A backup file contains a plaintext password and can be read by other users.

Telnet-related files are present, but no active Telnet service was identified on TCP port 23.

The services on TCP ports 3000 and 3001 appear to be part of the Holberton lab environment, so they are not considered LogiCorp security problems.

This audit shows that documentation should not be trusted without verification. The real system state must also be checked.

The next steps should focus on network segmentation, database isolation, firewall configuration, secure remote access, FTP access control, and protection of sensitive credentials and backup files.