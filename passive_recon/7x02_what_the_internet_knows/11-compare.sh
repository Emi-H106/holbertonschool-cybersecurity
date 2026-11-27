#!/bin/bash

set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

declare -A scores=(
    [Cerebra]=0
    [Yume]=0
    [Verdant]=0
)

worst_asset=""
worst_weight=0

# Add exposure points to an estate.
add_score() {
    local estate="$1"
    local weight="$2"
    scores[$estate]=$((scores[$estate] + weight))
}

# Track the highest-priority individual asset.
rank_asset() {
    local asset="$1"
    local weight="$2"

    if [[ "$weight" -gt "$worst_weight" ]]; then
        worst_weight=$weight
        worst_asset="$asset"
    fi
}

# Validate all required input files.
for i in {1..10}; do
    if [[ ! -s "$i-flag.txt" ]]; then
        echo "Missing or empty file: $i-flag.txt" >&2
        exit 1
    fi
done

# Task 1: Cerebra DNS exposure.
if [[ -n "$(cat 1-flag.txt)" ]]; then
    add_score Cerebra 2
fi

# Task 2: Yume certificate disclosure.
if grep -qE '\.yume\.lab$' 2-flag.txt; then
    add_score Yume 3
fi

# Task 3: Sensitive services.
mapfile -t services < 3-flag.txt

estates=(Cerebra Yume)
assets=("cerebra.lab:47808" "yume.lab:9000")

for i in 0 1; do
    read -r flag classification <<< "${services[$i]}"

    case "$classification" in
        ICS)  weight=10 ;;
        MGMT) weight=8 ;;
        DATA) weight=7 ;;
        AUTH) weight=7 ;;
        IOT)  weight=6 ;;
        *)    weight=0 ;;
    esac

    if [[ -n "$flag" ]]; then
        add_score "${estates[$i]}" "$weight"
        rank_asset "${assets[$i]}" "$weight"
    fi
done

# Task 4: Yume internal virtual host.
if [[ -n "$(cat 4-flag.txt)" ]]; then
    add_score Yume 6
    rank_asset "$(head -n 1 2-flag.txt)" 6
fi

# Task 5: Document metadata exposure.
mapfile -t metadata < 5-flag.txt

if [[ -n "${metadata[0]:-}" ]]; then
    add_score Cerebra 2
fi

if [[ -n "${metadata[1]:-}" ]]; then
    add_score Verdant 3
fi

# Task 6: Cerebra Git history exposure.
if [[ -n "$(cat 6-flag.txt)" ]]; then
    add_score Cerebra 5
fi

# Task 7: Verdant CMS and internal portal.
mapfile -t web < 7-flag.txt

if [[ -n "${web[0]:-}" ]]; then
    add_score Verdant 2
fi

if [[ -n "${web[1]:-}" ]]; then
    add_score Verdant 5
    rank_asset "verdant.lab" 5
fi

# Task 8: Personnel information.
mapfile -t personnel < 8-flag.txt

if [[ -n "${personnel[0]:-}" ]]; then
    add_score Cerebra 2
fi

if [[ -n "${personnel[1]:-}" ]]; then
    add_score Yume 2
fi

# Task 9: Historical secret exposure.
mapfile -t secret < 9-flag.txt

case "${secret[1]:-}" in
    APIKEY|TOKEN|PASSWORD|PRIVATEKEY)
        weight=9
        ;;
    CONFIG)
        weight=4
        ;;
    *)
        weight=0
        ;;
esac

if [[ -n "${secret[0]:-}" ]]; then
    add_score Yume "$weight"
    rank_asset "yume.lab" "$weight"
fi

# Task 10: breach and reputation intelligence.
mapfile -t intelligence < 10-flag.txt

# Validate the breach finding in Name Year format.
breach="${intelligence[0]:-}"

if [[ "$breach" =~ ^(.+)[[:space:]]([0-9]{4})$ ]]; then
    breach_name="${BASH_REMATCH[1]}"
    breach_year="${BASH_REMATCH[2]}"

    if [[ -n "$breach_name" && -n "$breach_year" ]]; then
        add_score Cerebra 4
    fi
fi

# Evaluate the IP reputation finding.
read -r ip reputation flag <<< "${intelligence[1]:-}"

if [[ "$reputation" =~ ^[0-9]+$ && -n "$flag" ]] &&
   (( 10#$reputation >= 7 )); then
    case "$ip" in
        127.22.0.10) add_score Cerebra 7 ;;
        127.22.0.20) add_score Yume 7 ;;
        127.22.0.30) add_score Verdant 7 ;;
    esac
fi

# Sort estates by exposure score in descending order.
ranking=$(
    for estate in Cerebra Yume Verdant; do
        printf '%s %s\n' "${scores[$estate]}" "$estate"
    done | sort -k1,1nr -k2,2
)

# Select the estate with the maximum exposure score.
max_score=-1
winner=""

while read -r score estate; do
    if [[ "$score" -gt "$max_score" ]]; then
        max_score="$score"
        winner="$estate"
    fi
done <<< "$ranking"

# Print exactly two lines.
printf '%s\n' "$winner" "$worst_asset"
