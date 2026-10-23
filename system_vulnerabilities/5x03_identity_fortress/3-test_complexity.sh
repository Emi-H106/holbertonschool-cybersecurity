
#!/bin/bash
# NovaTech - Password Complexity Testing

set -uo pipefail

echo '=== Password Complexity Testing ==='
echo
echo "Testing password policy enforcement..."
echo

if ! command -v pwscore >/dev/null 2>&1; then
    echo "ERROR: pwscore is not installed."
    echo "Install: sudo apt-get install -y libpwquality-tools"
    exit 1
fi

test_number=0
passed=0
failed=0

for test_pass in 'password' 'Password123' 'Ab1!' 'auditor2024' 'Str0ng!P@ssw0rd#2024'
do
    test_number=$((test_number + 1))

    case "$test_pass" in
        'password')
            description="common word"
            reason="Dictionary word"
            expected="REJECTED"
            ;;
        'Password123')
            description="no special char"
            reason="Missing special character"
            expected="REJECTED"
            ;;
        'Ab1!')
            description="too short"
            reason="Minimum length not met"
            expected="REJECTED"
            ;;
        'auditor2024')
            description="contains username"
            reason="Contains username"
            expected="REJECTED"
            ;;
        'Str0ng!P@ssw0rd#2024')
            description="valid"
            reason="Meets all requirements"
            expected="ACCEPTED"
            ;;
    esac

    echo "Test $test_number: \"$test_pass\" ($description)"

    if echo "$test_pass" | passwd auditor >/dev/null 2>&1; then
        result="ACCEPTED"
    else
        result="REJECTED"
    fi

    echo "  Result: $result"
    echo "  Reason: $reason"

    if [[ "$result" == "$expected" ]]; then
        passed=$((passed + 1))
    else
        failed=$((failed + 1))
        echo "  STATUS: FAILED"
    fi

    echo
done

if [[ "$failed" -eq 0 && "$passed" -eq 5 ]]; then
    echo "All complexity tests: PASSED"
    echo "Password policy is enforced correctly."
else
    echo "Complexity tests: FAILED ($passed/5 passed)"
    exit 1
fi
