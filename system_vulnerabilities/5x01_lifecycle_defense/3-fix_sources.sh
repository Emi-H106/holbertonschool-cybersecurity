#!/bin/bash

# Validate and disable invalid APT repositories.

set -euo pipefail

echo "=== APT Sources Validation ==="
echo

if [ "$EUID" -ne 0 ]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

valid=0
disabled=0
backup_dir="/var/backups/apt-sources"

mkdir -p "$backup_dir"

# Check whether a repository URL is reachable.
check_repo() {
    local url="$1"
    local suite="$2"
    local release_url="${url%/}/dists/$suite/InRelease"
    local fallback_url="${url%/}/dists/$suite/Release"

    if curl -fsIL --connect-timeout 5 --max-time 15 \
        "$release_url" >/dev/null 2>&1; then
        return 0
    fi

    if curl -fsIL --connect-timeout 5 --max-time 15 \
        "$fallback_url" >/dev/null 2>&1; then
        return 0
    fi

    return 1
}

# Validate the main sources.list.
echo "Checking main sources.list..."

main_file="/etc/apt/sources.list"
main_count=0
main_invalid=0

if [ -f "$main_file" ]; then
    cp -p "$main_file" "$backup_dir/sources.list.bak"

    while IFS= read -r line; do
        if [[ "$line" =~ ^[[:space:]]*deb[[:space:]] ]]; then
            read -r _ url suite _ <<< "$line"
            main_count=$((main_count + 1))

            if check_repo "$url" "$suite"; then
                valid=$((valid + 1))
            else
                echo "  INVALID: $url $suite"
                main_invalid=$((main_invalid + 1))
            fi
        fi
    done < "$main_file"

    if [ "$main_invalid" -eq 0 ]; then
        echo "  $main_count entries: All valid"
    else
        echo "  $main_count entries: $main_invalid invalid"

        temp_file=$(mktemp)

        while IFS= read -r line || [ -n "$line" ]; do
            if [[ "$line" =~ ^[[:space:]]*deb[[:space:]] ]]; then
                read -r _ url suite _ <<< "$line"

                if ! check_repo "$url" "$suite"; then
                    echo "# DISABLED: $line" >> "$temp_file"
                    disabled=$((disabled + 1))
                    continue
                fi
            fi

            echo "$line" >> "$temp_file"
        done < "$main_file"

        cat "$temp_file" > "$main_file"
        rm -f "$temp_file"
    fi
else
    echo "  sources.list not found"
fi

echo
echo "Checking sources.list.d/..."

shopt -s nullglob

for file in /etc/apt/sources.list.d/*.list; do
    filename=$(basename "$file")
    file_invalid=0
    file_valid=0

    while IFS= read -r line; do
        if [[ "$line" =~ ^[[:space:]]*deb[[:space:]] ]]; then
            read -r _ url suite _ <<< "$line"

            if check_repo "$url" "$suite"; then
                file_valid=$((file_valid + 1))
            else
                file_invalid=$((file_invalid + 1))
            fi
        fi
    done < "$file"

    if [ "$file_invalid" -gt 0 ]; then
        if [ "$file_valid" -eq 0 ]; then
            mv "$file" "$file.disabled"
            echo "  $filename: INVALID (repository not reachable)"
            echo "    Action: Renamed to $filename.disabled"
            disabled=$((disabled + file_invalid))
        else
            cp -p "$file" "$backup_dir/$filename.bak"

            temp_file=$(mktemp)

            while IFS= read -r line || [ -n "$line" ]; do
                if [[ "$line" =~ ^[[:space:]]*deb[[:space:]] ]]; then
                    read -r _ url suite _ <<< "$line"

                    if ! check_repo "$url" "$suite"; then
                        echo "# DISABLED: $line" >> "$temp_file"
                        disabled=$((disabled + 1))
                        continue
                    fi
                fi

                echo "$line" >> "$temp_file"
            done < "$file"

            cat "$temp_file" > "$file"
            rm -f "$temp_file"

            echo "  $filename: Invalid entries disabled"
        fi

        valid=$((valid + file_valid))
    else
        echo "  $filename: VALID"
        valid=$((valid + file_valid))
    fi
done

echo
echo "Running apt update..."

if apt-get update; then
    echo "  All repositories updated successfully."
else
    echo "  ERROR: Some repositories failed."
    exit 1
fi

echo
echo "Summary:"
echo "  Valid sources: $valid"
echo "  Disabled sources: $disabled"
