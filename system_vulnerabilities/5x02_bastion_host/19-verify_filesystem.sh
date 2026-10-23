#!/bin/bash

echo "=== Filesystem Hardening Verification ==="
echo

FAILED=0

check_options() {
    dir="$1"
    options=$(findmnt -n -o OPTIONS -M "$dir" 2>/dev/null)

    if [[ ",$options," == *,noexec,* ]] &&
       [[ ",$options," == *,nosuid,* ]] &&
       [[ ",$options," == *,nodev,* ]]; then
        echo "  $dir: noexec,nosuid,nodev ✓"
    else
        echo "  $dir: FAILED"
        FAILED=1
    fi
}

test_execution() {
    dir="$1"
    type="$2"

    echo "Testing $dir restrictions:"

    if [ "$type" = "binary" ]; then
        echo -n "  Creating test binary... "
    else
        echo -n "  Creating test script... "
    fi

    testfile=$(mktemp "$dir/test_exec.XXXXXX") || {
        echo "FAILED"
        FAILED=1
        return
    }

    printf '#!/bin/sh\necho EXECUTED\n' > "$testfile"
    chmod 755 "$testfile"

    echo "Done"

    echo -n "  Attempting execution... "

    result=$("$testfile" 2>&1)
    status=$?

    if [ "$status" -ne 0 ] &&
       echo "$result" | grep -qi "Permission denied"; then
        echo "BLOCKED ✓"
    else
        echo "FAILED"
        FAILED=1
    fi

    if [ "$dir" = "/tmp" ]; then
        echo -n "  Testing SUID... "

        options=$(findmnt -n -o OPTIONS -M /tmp)

        if [[ ",$options," == *,nosuid,* ]]; then
            echo "IGNORED ✓"
        else
            echo "FAILED"
            FAILED=1
        fi
    fi

    echo -n "  Cleanup... "
    rm -f "$testfile"
    echo "Done"
    echo
}

test_execution /tmp script
test_execution /var/tmp script
test_execution /dev/shm binary

echo "Mount options verified:"

check_options /tmp
check_options /var/tmp
check_options /dev/shm

echo

if [ "$FAILED" -eq 0 ]; then
    echo "All filesystem restrictions: ACTIVE"
else
    echo "Some filesystem restrictions: INACTIVE"
    exit 1
fi
