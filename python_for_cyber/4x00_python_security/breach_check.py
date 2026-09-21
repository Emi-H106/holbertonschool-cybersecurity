#!/usr/bin/env python3
"""BreachCheck main module."""

import argparse
import sys

def read_file(filename: str) -> list:
    """Read a file safely and return its lines as a list."""
    try:
        with open(filename, "r") as file:
            return file.readlines()
    except FileNotFoundError:
        print(
            f"[ERROR] File not found: {filename}",
            file=sys.stderr
        )
        sys.exit(1)
    except PermissionError:
        print(
            f"[ERROR] Permission denied: {filename}",
            file=sys.stderr
        )
        sys.exit(1)

def clean_data(lines: list) -> list:
    """Clean raw input lines and return valid data."""
    clean_lines = []

    for line in lines:
        clean_line = line.strip()

        if not clean_line:
            continue

        if clean_line.startswith("#"):
            continue

        clean_lines.append(clean_line)

    return clean_lines


def main():
    """Parse command-line arguments and run BreachCheck."""
    parser = argparse.ArgumentParser(
        description="Analyze leaked credentials for weak passwords."
    )

    parser.add_argument(
        "-f",
        "--file",
        required=True,
        help="Input file path"
    )

    parser.add_argument(
        "-v",
        "--verbose",
        action="store_true",
        help="Enable verbose output"
    )

    parser.add_argument(
        "-o",
        "--output",
        help="Output report file path"
    )

    args = parser.parse_args()

    lines = read_file(args.file)

    clean_lines = clean_data(lines)

    print("BreachCheck v1.0 startup...")


if __name__ == "__main__":
    main()
