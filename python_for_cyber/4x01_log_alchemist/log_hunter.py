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

class LogEntry:
    """Represent a normalized log entry."""

    def __init__(
        self,
        ip: str,
        timestamp: str,
        service: str,
        message: str,
        raw_line: str
    ):
        """Initialize a log entry."""
        self.ip = ip
        self.timestamp = timestamp
        self.service = service
        self.message = message
        self.raw_line = raw_line


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
        entry = LogEntry(
            ip=parsed_dict.get("ip", ""),
            timestamp=parsed_dict.get("date", ""),
            service="http",
            message=raw_line.strip(),
            raw_line=raw_line.strip()
        )

        entry.method = parsed_dict.get("method", "")
        entry.path = parsed_dict.get("path", "")
        entry.status = int(parsed_dict.get("status", 0))
        entry.user_agent = parsed_dict.get("user_agent", "")

        return entry

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

    for line in read_stream(args.file):
        apache_parsed = parse_apache_line(line)

        if apache_parsed:
            apache_count += 1
            entry = normalize_entry(
                apache_parsed,
                "apache",
                line
            )

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


if __name__ == "__main__":
    main()