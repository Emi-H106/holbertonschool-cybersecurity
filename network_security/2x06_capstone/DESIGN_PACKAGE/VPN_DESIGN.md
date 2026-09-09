# LogiCorp VPN Design

## 1. VPN Topology

WireGuard will be used for secure remote access.

The WireGuard server will run on the LogiCorp Gateway.

Remote administrators connect to the Gateway through the Internet using WireGuard.

    Remote Admin
    10.200.0.2
         |
         | WireGuard UDP 51820
         |
    LogiCorp Gateway
    10.200.0.1
         |
         | wg0
         |
    Internal Networks

SSH will not be directly accessible from the Internet.

Remote administrators must first connect to the VPN.

## 2. IP Addressing

The VPN network will use:

`10.200.0.0/24`

| Device | VPN IP |
|---|---|
| LogiCorp Gateway | `10.200.0.1` |
| Remote Admin | `10.200.0.2` |
| Other VPN clients | `10.200.0.3 - 10.200.0.254` |

The WireGuard interface will be `wg0`.

## 3. Access Control

VPN users do not have access to everything.

| Source | Destination | Service | Access |
|---|---|---|---|
| VPN Admin | Gateway | SSH TCP 22 | ALLOW |
| VPN Admin | Critical DB | TCP 3306 | ALLOW if needed |
| VPN Finance User | FTP Server | TCP 21 | ALLOW |
| VPN User | Other systems | Any | DENY by default |

This follows the least privilege principle.

## 4. Legacy FTP

Finance still needs the legacy FTP service.

Remote Finance users can use FTP through the WireGuard VPN.

The VPN encrypts the traffic while it travels through the Internet.

FTP will not be directly accessible from the Internet.

The FTP service should be replaced by a secure solution such as SFTP in the future.

## 5. Summary

WireGuard provides secure remote access to LogiCorp.

SSH is only available through the VPN. VPN users only have access to the systems they need.

All other access is denied by default.