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

    for line read_stream(args.file):
        parsed = parse_apache_line(line)

        if parsed:
            apache_count += 1

    total_parsed = apache_count + syslog_count

    if total_parsed == 0:
        print("[!] No data to process. Exiting.")
        return

    print(f"[*] Apache lines:  {apache_count}")
    print(f"[*] Syslog lines:  {syslog_count}")
    print(f"[*] Total parsed:  {total_parsed}")


if __name__ == "__main__":
    main()
