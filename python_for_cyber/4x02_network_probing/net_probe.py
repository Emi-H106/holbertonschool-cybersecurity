#!/usr/bin/env python3
"""NetProbe network scanning tool."""

import socket


def check_port(ip: str, port: int) -> bool:
    """Check whether a TCP port is open on the target."""
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.settimeout(1)

    try:
        sock.connect((ip, port))
        return True
    except (ConnectionRefusedError, socket.timeout, socket.gaierror):
        return False
    finally:
        sock.close()


def ping_sweep(subnet: str) -> list:
    """Scan port 80 on all hosts in a /24 subnet."""
    live_ips = []

    for host in range(1, 255):
        ip = f"{subnet}.{host}"

        if check_port(ip, 80):
            live_ips.append(ip)

    return live_ips


def get_banner(ip: str, port: int) -> str:
    """Retrieve a service banner from an open TCP port."""
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.settimeout(1)

    try:
        sock.connect((ip, port))

        if port != 22:
            sock.sendall(b"HEAD / HTTP/1.0\r\n\r\n")

        data = sock.recv(1024)

        if not data:
            return "Unknown"

        return data.decode(errors="ignore").strip()

    except (OSError, socket.timeout):
        return "Unknown"
    finally:
        sock.close()


def scan_ports(ip: str, start_port: int, end_port: int) -> list:
    """Scan a range of TCP ports on a target."""
    results = []

    print(f"Scanning {ip} from {start_port} to {end_port}...")

    for port in range(start_port, end_port + 1):
        if check_port(ip, port):
            banner = get_banner(ip, port)

            results.append({
                "port": port,
                "service": banner
            })

            print(f"[+] Port {port} Open: {banner}")

    return results


def main() -> None:
    """Initialize the NetProbe application."""
    print("NetProbe v1.0 initialized...")
    print(f"Port 80 is open: {check_port('google.com', 80)}")
    print(f"Port 81 is open: {check_port('google.com', 81)}")
    print(ping_sweep("192.168.1"))


if __name__ == "__main__":
    main()
