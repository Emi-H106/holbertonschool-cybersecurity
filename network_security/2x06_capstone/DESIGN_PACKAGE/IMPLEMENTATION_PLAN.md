# LogiCorp Implementation Plan

## 1. Backup Current Configuration

Before making changes, save the current firewall and network configurations.

Example:

```bash
sudo nft list ruleset > nftables-backup.conf
```

This backup can be used if something goes wrong.

Rollback:

```bash
sudo nft -f nftables-backup.conf
```

---

## 2. Configure WireGuard VPN

Install and configure WireGuard on the LogiCorp Gateway.

The VPN will use:

- VPN network: `10.200.0.0/24`
- Gateway VPN IP: `10.200.0.1`
- Remote Admin VPN IP: `10.200.0.2`
- WireGuard port: `UDP 51820`
- Interface: `wg0`

Start WireGuard:

```bash
sudo wg-quick up wg0
```

Public SSH must stay available during this step to avoid lockout.

Rollback:

```bash
sudo wg-quick down wg0
```

---

## 3. Test the VPN

Connect the Remote Admin to the WireGuard VPN.

Check that the VPN works and that SSH is accessible through the VPN.

Do not block public SSH until the VPN connection has been tested successfully.

---

## 4. Apply Firewall Rules

Add the required ALLOW rules before applying Default Deny.

Allow:

- Loopback traffic
- Established and related connections
- WireGuard UDP 51820
- SSH TCP 22 from the VPN
- Finance access to the FTP server
- Required Internet traffic

Test the required connections before continuing.

Rollback:

Restore the firewall backup if an important connection stops working.

---

## 5. Restrict Public SSH

After SSH through the VPN works, block direct SSH access from the Internet.

SSH TCP 22 will only be accessible from the VPN.

Rollback:

Restore the previous firewall configuration if VPN administration stops working.

---

## 6. Segment the Network

Separate the network into:

- Guest Zone
- Office LAN
- Finance Zone
- DMZ
- Critical Zone
- VPN Zone

Guest users must not access internal networks.

Test each zone after the changes.

Rollback:

Restore the previous network and firewall configuration if a required service stops working.

---

## 7. Secure Legacy FTP

Keep the FTP service because Finance still needs it.

Allow FTP only from the Finance Zone and authorized VPN users.

Block FTP from the Internet and other unauthorized zones.

Rollback:

Restore the previous FTP access rule if Finance cannot use the service.

---

## 8. Protect the Critical Database

The database on TCP 3306 must be isolated from unauthorized networks.

Only approved systems or administrators can access it.

Required business access must be tested before blocking other connections.

Rollback:

Restore the previous database access rule if a required application stops working.

---

## 9. Apply Default Deny

After all required services have been tested, apply the final firewall policies:

- INPUT: DROP
- FORWARD: DROP
- OUTPUT: ACCEPT

All other traffic will be denied by default.

Rollback:

```bash
sudo nft -f nftables-backup.conf
```

---

## 10. Final Validation

Check the final configuration:

```bash
sudo wg show
sudo nft list ruleset
```

Verify that:

- VPN connection works
- SSH works through the VPN
- Public SSH is blocked
- Finance FTP works
- Guest cannot access internal networks
- Database access is restricted
- Required Internet access still works

If all tests are successful, save the final configuration.