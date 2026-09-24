#!/usr/bin/env python3
"""Unit tests for BreachCheck."""

import unittest

from utils import validate_line, hash_password
from breach_check import check_policy


class TestBreachCheck(unittest.TestCase):
    """Test BreachCheck functions."""

    def test_validate_line_valid(self):
        """Test a valid email and password format."""
        self.assertTrue(
            validate_line("user@example.com:password123")
        )

    def test_validate_line_invalid(self):
        """Test an invalid credential format."""
        self.assertFalse(
            validate_line("invalid-format")
        )

    def test_validate_line_missing_parts(self):
        """Test credentials with missing parts."""
        self.assertFalse(
            validate_line("user@example.com:")
        )

    def test_policy_short_password(self):
        """Test that a short password is weak."""
        self.assertEqual(
            check_policy("abc123", 8),
            "WEAK"
        )

    def test_policy_numeric_password(self):
        """Test a numeric password."""
        self.assertEqual(
            check_policy("12345678", 8),
            "WEAK"
        )

    def test_policy_compliant_password(self):
        """Test a compliant password."""
        self.assertEqual(
            check_policy("hello123", 8),
            "COMPLIANT"
        )

    def test_hash_password_consistent(self):
        """Test that hashing the same input gives the same result."""
        first_hash = hash_password("password123", "breachcheck")
        second_hash = hash_password("password123", "breachcheck")

        self.assertEqual(first_hash, second_hash)


if __name__ == "__main__":
    unittest.main()
