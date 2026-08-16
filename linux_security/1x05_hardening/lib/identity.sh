#!/bin/bash

configure_password_policy() {
    PAM_FILE="/etc/pam.d/common-password"

    sed -i '/pam_pwquality.so/d' "$PAM_FILE"

    echo "password requisite pam_pwquality.so retry=3 minlen=$PASS_MIN_LEN ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1" >> "$PAM_FILE"

    sed -i '/^PASS_MAX_DAYS/d' /etc/login.defs
    echo "PASS_MAX_DAYS $PASS_MAX_DAYS" >> /etc/login.defs

    sed -i '/^PASS_MIN_LEN/d' /etc/login.defs
    echo "PASS_MIN_LEN $PASS_MIN_LEN" >> /etc/login.defs

    log "Password policy configured"
}

configure_lockout() {
    PAM_AUTH="/etc/pam.d/common-auth"

    sed -i '/pam_faillock.so/d' "$PAM_AUTH"

    echo "auth required pam_faillock.so preauth silent deny=$FAIL_LOCK_ATTEMPTS unlock_time=900" >> "$PAM_AUTH"
    echo "auth [default=die] pam_faillock.so authfail deny=$FAIL_LOCK_ATTEMPTS unlock_time=900" >> "$PAM_AUTH"

    log "Account lockout policy configured"
}

cleanup_users() {
    REMOVED_USERS_COUNT=0
    REMOVED_USERS=""

    while IFS=: read -r username _ uid _; do
        if [ "$uid" -gt 1000 ]; then
            if ! id -nG "$username" 2>/dev/null | grep -qwE 'sudo|wheel'; then

                if userdel -r "$username" 2>/dev/null; then
                    REMOVED_USERS_COUNT=$((REMOVED_USERS_COUNT + 1))

                    if [ -z "$REMOVED_USERS" ]; then
                        REMOVED_USERS="$username"
                    else
                        REMOVED_USERS="$REMOVED_USERS, $username"
                    fi

                    log "INFO" "Deleted unauthorized user: $username"
                else
                    log "WARN" "Could not delete user: $username"
                fi
            fi
        fi
    done < /etc/passwd
}

lock_root_password() {
    passwd -l root
    log "Root password locked"
}
