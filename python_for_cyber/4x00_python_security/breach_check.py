#!/usr/bin/env python3
"""BreachCheck main module."""

import argparse
import configparser
import logging
import sys

from utils import read_file, clean_data, validate_line, hash_password


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


def check_policy(password: str, min_length: int) -> str:
    """Return WEAK or COMPLIANT based on the password policy."""
    common_passwords = ["password", "123456"]

    if len(password) < min_length:
        return "WEAK"

    if password.isalpha():
        return "WEAK"

    if password.isdigit():
        return "WEAK"

    if password in common_passwords:
        return "WEAK"

    return "COMPLIANT"


def load_config():
    """Load security settings from config.ini."""
    config = configparser.ConfigParser()

    if not config.read("config.ini"):
        logging.error("[ERROR] config file missing")
        sys.exit(1)

    return config


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

    config = load_config()

    salt = config["SECURITY"]["Salt"]
    min_length = config.getint("SECURITY", "MinLength")

    logging.info("BreachCheck v1.0 startup...")
    logging.info("Processing file...")

    lines = read_file(args.file)
    clean_lines = clean_data(lines)

    valid_lines = []

    for line in clean_lines:
        if validate_line(line):
            valid_lines.append(line)

    for line in valid_lines:
        email, password = line.split(":", 1)
        status = check_policy(password, min_length)

        logging.info("%s: %s", email, status)

        if status == "WEAK":
            hashed_password = hash_password(password, salt)


if __name__ == "__main__":
    main()
