#!/bin/bash

# NovaTech - PAM Configuration Audit
# Read-only audit of authentication settings

set -u

echo "=== PAM Configuration Audit ==="
echo

has_module() {
    local file="$1"
    local module="$2"

    [[ -r "$file" ]] &&
        grep -Eq "^[[:space:]]*[^#[:space:]].*${module}" "$file"
}

show_module() {
    local file="$1"
    local module="$2"
    local description="$3"

    if has_module "$file" "$module"; then
        echo "  ${module}: ${description}"
    else
        echo "  ${module}: NOT CONFIGURED"
    fi
}

echo "/etc/pam.d/common-auth:"
show_module /etc/pam.d/common-auth \
    "pam_unix.so" "Standard password authentication"
show_module /etc/pam.d/common-auth \
    "pam_deny.so" "Fallback deny"
echo

echo "/etc/pam.d/common-password:"
show_module /etc/pam.d/common-password \
    "pam_unix.so" "Password change handling"

if has_module /etc/pam.d/common-password "pam_pwquality.so" ||
   has_module /etc/pam.d/common-password "pam_cracklib.so"; then
    echo "  Complexity enforcement: CONFIGURED"
else
    echo "  Complexity enforcement: NONE"
fi

if has_module /etc/pam.d/common-password "pam_pwhistory.so" ||
   grep -Eq '^[[:space:]]*[^#[:space:]].*pam_unix\.so.*remember=' \
       /etc/pam.d/common-password 2>/dev/null; then
    echo "  History enforcement: CONFIGURED"
else
    echo "  History enforcement: NONE"
fi
echo

echo "/etc/pam.d/sshd:"

if grep -Eq '^[[:space:]]*@include[[:space:]]+common-auth' \
    /etc/pam.d/sshd 2>/dev/null; then
    echo "  @include common-auth"
else
    echo "  @include common-auth: NOT FOUND"
fi

if has_module /etc/pam.d/sshd "pam_google_authenticator.so" ||
   has_module /etc/pam.d/sshd "pam_oath.so" ||
   has_module /etc/pam.d/sshd "pam_u2f.so"; then
    echo "  MFA modules: CONFIGURED"
else
    echo "  MFA modules: NONE"
fi
echo

echo "Account Lockout:"

if grep -REq '^[[:space:]]*[^#[:space:]].*pam_faillock\.so' \
    /etc/pam.d 2>/dev/null; then
    echo "  pam_faillock: CONFIGURED"
else
    echo "  pam_faillock: NOT CONFIGURED"
fi

if grep -REq '^[[:space:]]*[^#[:space:]].*pam_tally2\.so' \
    /etc/pam.d 2>/dev/null; then
    echo "  pam_tally2: CONFIGURED"
else
    echo "  pam_tally2: NOT CONFIGURED"
fi
echo

get_login_def() {
    local key="$1"
    local value

    value=$(awk -v key="$key" '
        $1 == key && $1 !~ /^#/ { value=$2 }
        END { print value }
    ' /etc/login.defs 2>/dev/null)

    echo "${value:-NOT SET}"
}

max_days=$(get_login_def PASS_MAX_DAYS)
min_days=$(get_login_def PASS_MIN_DAYS)
warn_days=$(get_login_def PASS_WARN_AGE)

echo "Password Aging:"

if [[ "$max_days" == "99999" ]]; then
    echo "  Default max days: 99999 (effectively disabled)"
else
    echo "  Default max days: $max_days"
fi

echo "  Default min days: $min_days"
echo "  Default warn days: $warn_days"
echo

get_ssh_setting() {
    local key="$1"
    local value

    if command -v sshd >/dev/null 2>&1; then
        value=$(sshd -T 2>/dev/null |
            awk -v key="$key" '$1 == key { print $2; exit }')
    elif [[ -x /usr/sbin/sshd ]]; then
        value=$(/usr/sbin/sshd -T 2>/dev/null |
            awk -v key="$key" '$1 == key { print $2; exit }')
    else
        value=""
    fi

    echo "${value:-UNKNOWN}"
}

password_auth=$(get_ssh_setting passwordauthentication)
pubkey_auth=$(get_ssh_setting pubkeyauthentication)
challenge_auth=$(get_ssh_setting kbdinteractiveauthentication)

echo "SSH Authentication:"

if [[ "$password_auth" == "yes" ]]; then
    echo "  PasswordAuthentication: yes (INSECURE)"
else
    echo "  PasswordAuthentication: $password_auth"
fi

echo "  PubkeyAuthentication: $pubkey_auth"
echo "  ChallengeResponseAuthentication: $challenge_auth"
echo

weak=0

[[ "$password_auth" == "yes" ]] && weak=1

if ! has_module /etc/pam.d/common-password "pam_pwquality.so"; then
    weak=1
fi

if ! grep -REq '^[[:space:]]*[^#[:space:]].*pam_faillock\.so' \
    /etc/pam.d 2>/dev/null; then
    weak=1
fi

if [[ "$weak" -eq 1 ]]; then
    echo "Summary: Identity controls are WEAK"
else
    echo "Summary: Identity controls require further review"
fi
