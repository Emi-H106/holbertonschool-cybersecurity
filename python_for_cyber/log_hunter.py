#!/usr/bin/env python3
"""LogHunter - Log Analysis Engine."""

import argparse
from typing import Generator


def read_stream(file_path: str) -> Generator[str, None, None]:
    """Read a log file one line at a time."""
    try:
        with open(file_path, "r") as file:
            for line in file:
                yield line
    except FileNotFoundError:
        print(f"[ERROR] File not found: {file_path}")


def main() -> None:
    """Run the LogHunter command-line interface."""
    parser = argparse.ArgumentParser()
    parser.add_argument("file", help="Path to the log file")
    args = parser.parse_args()

    print("[*] LogHunter - Log Analysis Engine")
    print(f"[*] Reading: {args.file}")

    line_count = 0

    for _ in read_stream(args.file):
        line_count += 1

    if line_count == 0:
        print("[!] No data to process. Exiting.")
        return

    print(f"[*] Lines read: {line_count}")


if __name__ == "__main__":
    main()
