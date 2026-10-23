#!/bin/bash
# NovaTech - Password Complexity Testing

set -uo pipefail

echo '=== Password Complexity Testing ==='
echo
echo "Testing password policy enforcement..."
echo

if ! command -v python3 >/dev/null 2>&1; then
    echo "ERROR: Python 3 is required."
    exit 1
fi

if ! python3 -c "import pwquality" 2>/dev/null; then
    echo "ERROR: Python pwquality module is missing."
    echo "Install it with: sudo apt-get install -y python3-pwquality"
    exit 1
fi

python3 <<'PY'
import pwquality

settings = pwquality.PWQSettings()
settings.read_config()

username = "auditor"

tests = [
    ("password", "common word", False, "Dictionary word"),
    ("Password123", "no special char", False,
     "Missing special character"),
    ("Ab1!", "too short", False, "Minimum length not met"),
    ("auditor2024", "contains username", False,
     "Contains username"),
    ("Str0ng!P@ssw0rd#2024", "valid", True,
     "Meets all requirements"),
]

passed = 0

for number, (password, description, expected, reason) in enumerate(
    tests, start=1
):
    print(f'Test {number}: "{password}" ({description})')

    try:
        settings.check(password, None, username)
        accepted = True
        detail = ""
    except pwquality.PWQError as error:
        accepted = False
        detail = str(error)

    result = "ACCEPTED" if accepted else "REJECTED"

    print(f"  Result: {result}")
    print(f"  Reason: {reason}")

    if detail:
        print(f"  Policy feedback: {detail}")

    if accepted == expected:
        passed += 1
    else:
        print("  STATUS: FAILED")

    print()

if passed == len(tests):
    print("All complexity tests: PASSED")
    print("Password policy is enforced correctly.")
else:
    print(f"Complexity tests: FAILED ({passed}/{len(tests)} passed)")
    raise SystemExit(1)
PY
