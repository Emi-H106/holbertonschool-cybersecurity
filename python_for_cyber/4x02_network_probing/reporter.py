#!/usr/bin/env python3
"""JSON reporting functions for NetProbe."""

import json


def save_json_report(results: list, output: str) -> None:
    """Save scan results to a JSON file."""
    with open(output, "w", encoding="utf-8") as file:
        json.dump(results, file, indent=2)
