#!/usr/bin/env python3
"""BreachCheck main module."""

import argparse
import logging
import re
import sys


def setup_logging():
    """Configure console and file logging."""
    logging.getLogger().setLevel(logging.DEBUG)

    formatter = logging.Formatter(
        "%(asctime)s - %(levelname)s - %(message)s"
    )

    console_handler = logging.StreamHandler()
    console_handler.setLevel(logging.INFO)
    console_handler.setFormatter(formatter)

    file_handler = logging.FileHandler("breach_check.log")
    file_handler.setLevel(logging.DEBUG)
    file_handler.setFormatter(formatter)

    logging.getLogger().addHandler(console_handler)
    logging.getLogger().addHandler(file_handler)


def read_file(filename: str) -> list:
    """Read a file safely and return its lines as a list."""
    try:
        with open(filename, "r") as file:
            return file.readlines()
    except FileNotFoundError:
        logging.error("File not found: %s", filename)
        sys.exit(1)
    except PermissionError:
        logging.error("Permission denied: %s", filename)
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


def validate_line(line: str) -> bool:
    """Return True if the line follows the email:password format."""
    logging.debug("Starting regex check")

    pattern = r"^[^@\s:]+@[^@\s:]+\.[^@\s:]+:[^:\s]+$"

    return bool(re.fullmatch(pattern, line))


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

    setup_logging()

    logging.info("BreachCheck v1.0 startup...")
    logging.info("Processing file...")

    lines = read_file(args.file)
    clean_lines = clean_data(lines)

    valid_lines = []

    for line in clean_lines:
        if validate_line(line):
            valid_lines.append(line)


if __name__ == "__main__":
    main()
    