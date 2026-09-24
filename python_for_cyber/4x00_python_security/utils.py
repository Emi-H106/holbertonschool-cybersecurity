#!/usr/bin/env python3
"""Utility functions for BreachCheck."""

import hashlib
import re
import logging
import sys

def read_file(filename: str) -> list:
    """Read a file safely and return its lines as a list."""
    try:
        with open(filename, "r") as file:
            for line in file:
                yield line
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


def hash_password(password: str, salt: str) -> str:
    """Return the SHA-256 hash of a password combined with a salt."""
    salted_password = password.encode() + salt.encode()
    return hashlib.sha256(salted_password).hexdigest()
