#!/usr/bin/env python3
"""Utility functions for NetProbe."""

import random
import time


def apply_delay(delay: float) -> None:
    """Apply a delay before a scan attempt."""
    if delay > 0:
        print(
            f"[DEBUG] Sleeping {delay}s before next packet..."
        )
        time.sleep(delay)


def randomize_ports(ports: list) -> list:
    """Shuffle a list of ports."""
    random.shuffle(ports)
    return ports
