#!/bin/bash
# NovaTech - Test SSH Multi-Factor Authentication
# Verify SSH public key + TOTP requirements.

set -Eeuo pipefail

PAM_CONFIG="/etc/pam.d/sshd"
SSHD_CONFIG="/etc/ssh/sshd_config"

TARGET_USER="${SUDO_USER:-$(whoami)}"
TARGET_HOST="${1:-127.0.0.1}"

USER_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)
TOTP_FILE="$USER_HOME/.google_authenticator"
SSH_KEY="$USER_HOME/.ssh/id_ed25519"

PASSED=0
FAILED=0

pass() {
    echo "  Result: CORRECT"
    PASSED=$((PASSED + 1))
}

fail() {
    echo "  Result: FAILED"
    FAILED=$((FAILED + 1))
}

echo "=== MFA Testing ==="
echo
echo "Testing authentication requirements..."
echo

# Check prerequisites
for cmd in ssh sshd grep stat timeout; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "ERROR: Missing command: $cmd"
        exit 1
    fi
done

if [[ ! -f "$PAM_CONFIG" || ! -f "$SSHD_CONFIG" ]]; then
    echo "ERROR: SSH configuration files not found."
    exit 1
fi

# Read effective SSH settings
if [[ $EUID -eq 0 ]]; then
    EFFECTIVE_CONFIG=$(sshd -T \
        -C "user=$TARGET_USER,host=$TARGET_HOST,addr=127.0.0.1")
else
    EFFECTIVE_CONFIG=$(sudo sshd -T \
        -C "user=$TARGET_USER,host=$TARGET_HOST,addr=127.0.0.1")
fi

# Test 1: SSH key only
echo "Test 1: SSH with key only (no TOTP)"
echo "  Expected: Prompt for verification code"

if [[ -f "$SSH_KEY" ]]; then

    SSH_OUTPUT=$(timeout 10 ssh -i "$SSH_KEY" \
        -o BatchMode=yes \
        -o PasswordAuthentication=no \
        -o KbdInteractiveAuthentication=no \
        -o PreferredAuthentications=publickey \
        -o StrictHostKeyChecking=accept-new \
        -o ConnectTimeout=5 \
        "$TARGET_USER@$TARGET_HOST" true 2>&1) && SSH_RC=0 || SSH_RC=$?

    if [[ $SSH_RC -ne 0 ]] &&
       grep -qx \
       'authenticationmethods publickey,keyboard-interactive' \
       <<< "$EFFECTIVE_CONFIG"; then

        pass
    else
        fail
    fi
else
    echo "  SSH private key not found."
    fail
fi

echo

# Test 2: SSH without public key
echo "Test 2: SSH with TOTP only (no key)"
echo "  Expected: Connection refused"

SSH_OUTPUT=$(timeout 10 ssh \
    -o PubkeyAuthentication=no \
    -o PasswordAuthentication=no \
    -o BatchMode=yes \
    -o StrictHostKeyChecking=accept-new \
    -o ConnectTimeout=5 \
    "$TARGET_USER@$TARGET_HOST" true 2>&1) && SSH_RC=0 || SSH_RC=$?

if [[ $SSH_RC -ne 0 ]] &&
   grep -qx \
   'authenticationmethods publickey,keyboard-interactive' \
   <<< "$EFFECTIVE_CONFIG"; then

    pass
else
    fail
fi

echo

# Test 3: PAM configuration
echo "Test 3: PAM configuration check"

if grep -Eq \
    '^[[:space:]]*auth[[:space:]]+required[[:space:]]+pam_google_authenticator\.so([[:space:]]|$)' \
    "$PAM_CONFIG"; then

    echo "  pam_google_authenticator.so: Present"
    PASSED=$((PASSED + 1))
else
    echo "  pam_google_authenticator.so: MISSING"
    FAILED=$((FAILED + 1))
fi

echo

# Test 4: SSH configuration
echo "Test 4: SSH configuration check"

if grep -qx \
    'authenticationmethods publickey,keyboard-interactive' \
    <<< "$EFFECTIVE_CONFIG"; then

    echo "  AuthenticationMethods: publickey,keyboard-interactive"
    PASSED=$((PASSED + 1))
else
    echo "  AuthenticationMethods: INCORRECT"
    FAILED=$((FAILED + 1))
fi

if grep -qx 'kbdinteractiveauthentication yes' \
    <<< "$EFFECTIVE_CONFIG"; then

    echo "  ChallengeResponseAuthentication: yes"
    PASSED=$((PASSED + 1))
else
    echo "  ChallengeResponseAuthentication: INCORRECT"
    FAILED=$((FAILED + 1))
fi

echo

# Test 5: User TOTP configuration
echo "Test 5: User TOTP configuration"

if [[ -f "$TOTP_FILE" ]]; then
    echo "  ~/.google_authenticator: Exists"
    PASSED=$((PASSED + 1))
else
    echo "  ~/.google_authenticator: MISSING"
    FAILED=$((FAILED + 1))
fi

if [[ -f "$TOTP_FILE" ]]; then
    PERMISSIONS=$(stat -c "%a" "$TOTP_FILE")

    if [[ "$PERMISSIONS" == "600" ]]; then
        echo "  Permissions (600): Correct"
        PASSED=$((PASSED + 1))
    else
        echo "  Permissions (600): INCORRECT ($PERMISSIONS)"
        FAILED=$((FAILED + 1))
    fi
else
    echo "  Permissions (600): Cannot verify"
    FAILED=$((FAILED + 1))
fi

echo

# Final summary
echo "=== MFA Test Summary ==="
echo "  Passed: $PASSED"
echo "  Failed: $FAILED"
echo

if [[ $FAILED -eq 0 ]]; then
    echo "All MFA tests: PASSED"
    echo "MFA requirements appear correctly configured."
    echo "Complete a manual key + TOTP login to verify end-to-end authentication."
else
    echo "MFA tests: FAILED"
    echo "Review SSH and PAM configuration."
    exit 1
fi
