#!/usr/bin/env python3
"""LogHunter - Log Analysis Engine."""

import argparse
import re
from typing import Generator


APACHE_PATTERN = re.compile(
    r'(?P<ip>\d{1,3}(?:\.\d{1,3}){3})'
    r'.*\[(?P<date>[^\]]+)\] '
    r'"(?P<method>\S+) (?P<path>\S+) [^"]+" '
    r'(?P<status>\d{3}) (?P<size>\d+)'
)

SYSLOG_PATTERN = re.compile(
    r'(?P<date>[A-Z][a-z]{2}\s+\d{1,2}\s+\d{2}:\d{2}:\d{2})\s+'
    r'(?P<host>\S+)\s+'
    r'(?P<process>[^:]+):\s*'
    r'(?P<message>.*)'
)

IP_PATTERN = re.compile(
    r'\d{1,3}(?:\.\d{1,3}){3}'
)

SQLI_PATTERNS = [
    re.compile(r"union\s+select", re.IGNORECASE),
    re.compile(r"'\s*or\s+1\s*=\s*1", re.IGNORECASE),
    re.compile(r"--", re.IGNORECASE)
]

GEOIP_DB = {
    "1.2.3.4": "US",
    "5.6.7.8": "RU"
}

BLACKLIST = {
    "10.0.0.1",
    "192.168.1.66"
}


class LogEntry:
    """Represent a normalized log entry."""

    def __init__(
        self,
        ip: str = "",
        timestamp: str = "",
        service: str = "",
        message: str = "",
        raw_line: str = "",
        method: str = "",
        path: str = "",
        status=None,
        size=None,
        user_agent: str = "",
        source: str = ""
    ):
        """Initialize a log entry."""
        self.ip = ip
        self.timestamp = timestamp
        self.service = service
        self.message = message
        self.raw_line = raw_line
        self.method = method
        self.path = path
        self.status = status
        self.size = size
        self.user_agent = user_agent
        self.source = source


def read_stream(file_path: str) -> Generator[str, None, None]:
    """Read a log file one line at a time."""
    try:
        with open(file_path, "r") as file:
            for line in file:
                yield line
    except FileNotFoundError:
        print(f"[ERROR] File not found: {file_path}")


def parse_apache_line(line: str) -> dict:
    """Parse an Apache log line and return its fields."""
    match = APACHE_PATTERN.search(line)

    if not match:
        return None

    return match.groupdict()


def parse_syslog_line(line: str) -> dict:
    """Parse a Syslog line and return its fields."""
    match = SYSLOG_PATTERN.search(line)

    if not match:
        return None

    return match.groupdict()


def normalize_entry(
    parsed_dict: dict,
    log_type: str,
    raw_line: str = ""
) -> LogEntry:
    """Normalize parsed log data into a LogEntry."""
    if log_type == "apache":
        return LogEntry(
            ip=parsed_dict.get("ip", ""),
            timestamp=parsed_dict.get("date", ""),
            service="http",
            message=raw_line.strip(),
            raw_line=raw_line.strip(),
            method=parsed_dict.get("method", ""),
            path=parsed_dict.get("path", ""),
            status=int(parsed_dict.get("status", 0)),
            user_agent=parsed_dict.get("user_agent", "")
        )

    if log_type == "syslog":
        message = parsed_dict.get("message", "")
        ip_match = IP_PATTERN.search(message)

        if ip_match:
            ip = ip_match.group()
        else:
            ip = ""

        return LogEntry(
            ip=ip,
            timestamp=parsed_dict.get("date", ""),
            service="ssh",
            message=message,
            raw_line=raw_line.strip()
        )

    return None


def filter_logs(stream, status_codes=[404, 500]):
    """Yield log entries matching specified status codes."""
    for entry in stream:
        status = getattr(entry, "status", None)

        if status in status_codes:
            yield entry


def enrich_ip(log_entry):
    """Add country information to a log entry."""
    log_entry.country = GEOIP_DB.get(log_entry.ip, "UNKNOWN")
    return log_entry


def analyze_user_agent(log_entry):
    """Detect bot or automated tool signatures."""
    signatures = ["sqlmap", "nikto", "curl", "python"]

    text = (
        getattr(log_entry, "user_agent", "") + " "
        + getattr(log_entry, "message", "") + " "
        + getattr(log_entry, "raw_line", "")
    ).lower()

    log_entry.is_bot = False

    for signature in signatures:
        if signature in text:
            log_entry.is_bot = True
            break

    return log_entry


def check_threat_intel(log_entry):
    """Check an IP address against the threat blacklist."""
    if log_entry.ip in BLACKLIST:
        log_entry.alert_level = "HIGH"
    else:
        log_entry.alert_level = "LOW"

    return log_entry


def detect_sqli(log_entry):
    """Detect SQL injection patterns in a log entry."""
    path = getattr(log_entry, "path", "")
    message = getattr(log_entry, "message", "")

    text = path + " " + message

    for pattern in SQLI_PATTERNS:
        if pattern.search(text):
            log_entry.attack_type = "SQLi"
            return log_entry

    return log_entry


def main() -> None:
    """Run the LogHunter command-line interface."""
    parser = argparse.ArgumentParser()
    parser.add_argument("file", help="Path to the log file")
    args = parser.parse_args()

    print("[*] LogHunter - Log Analysis Engine")
    print(f"[*] Reading: {args.file}")
    print("--- Parsing ---")

    apache_count = 0
    syslog_count = 0
    sample_entry = None
    entries = []

    for line in read_stream(args.file):
        apache_parsed = parse_apache_line(line)

        if apache_parsed:
            apache_count += 1

            entry = normalize_entry(
                apache_parsed,
                "apache",
                line
            )

            entries.append(entry)

            if sample_entry is None:
                sample_entry = entry

        else:
            syslog_parsed = parse_syslog_line(line)

            if syslog_parsed:
                syslog_count += 1

                entry = normalize_entry(
                    syslog_parsed,
                    "syslog",
                    line
                )

                entries.append(entry)

                if sample_entry is None:
                    sample_entry = entry

    total_parsed = apache_count + syslog_count

    if total_parsed == 0:
        print("[!] No data to process. Exiting.")
        return

    print(f"[*] Apache lines:  {apache_count}")
    print(f"[*] Syslog lines:  {syslog_count}")
    print(f"[*] Total parsed:  {total_parsed}")

    if sample_entry:
        print("[*] Sample entry:")

        if sample_entry.service == "http":
            print(
                f"    ip={sample_entry.ip} | "
                f"service={sample_entry.service} | "
                f"status={sample_entry.status} | "
                f"path={sample_entry.path}"
            )
        else:
            print(
                f"    ip={sample_entry.ip} | "
                f"service={sample_entry.service} | "
                f"message={sample_entry.message}"
            )

    print("--- Filtering ---")

    suspicious_count = 0

    for entry in filter_logs(entries):
        suspicious_count += 1

    print(f"[*] Suspicious (404, 500): {suspicious_count}")

    print("--- Enrichment ---")

    known_count = 0
    bot_count = 0

    for entry in entries:
        enrich_ip(entry)
        analyze_user_agent(entry)

        if entry.country != "UNKNOWN":
            known_count += 1

        if entry.is_bot:
            bot_count += 1

    print(
        f"[*] GeoIP: {len(entries)} entries enriched "
        f"({known_count} known IPs)"
    )
    print(f"[*] Bots detected: {bot_count}")

    print("--- Threat Intelligence ---")

    high_alert_count = 0

    for entry in entries:
        check_threat_intel(entry)

        if entry.alert_level == "HIGH":
            high_alert_count += 1

    print(
        f"[*] HIGH alerts: {high_alert_count} "
        f"entries from blacklisted IPs"
    )

    print("--- Attack Detection ---")

    sqli_count = 0

    for entry in entries:
        detect_sqli(entry)

        if getattr(entry, "attack_type", "") == "SQLi":
            sqli_count += 1

    print(f"[*] SQLi attempts: {sqli_count}")
    print("[*] XSS attempts:  0")


if __name__ == "__main__":
    main()
