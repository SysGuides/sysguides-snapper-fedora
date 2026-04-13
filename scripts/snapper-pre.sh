#!/usr/bin/env bash
set -e

# snapper-pre.sh
# ----------------
# Creates a PRE snapshot before a DNF5 transaction begins.
#
# This script:
# - Generates a description using snapper-desc.sh
# - Stores the description and snapshot number in /run for later use
#
# The stored data is used by the POST script to:
# - Pair snapshots correctly
# - Improve snapshot descriptions (especially for GUI installs)
#
# Project: sysguides-snapper-fedora
# Author: Madhu Desai (SysGuides)
# Website: https://sysguides.com
# GitHub: https://github.com/SysGuides/sysguides-snapper-fedora

PID="$1"
STATE_DIR="/run/snapper-actions"

# Ensure runtime directory exists with secure permissions
mkdir -p "$STATE_DIR"
chmod 700 "$STATE_DIR"

# On a fresh setup, DNF5 may fail with "filesystem error: cannot copy: packages.toml"
# if this directory is missing, leaving an orphaned PRE snapshot with no POST.
# This block ensures the directory exists before the transaction proceeds.
if [[ ! -d /usr/lib/sysimage/libdnf5 ]]; then
    mkdir -p /usr/lib/sysimage/libdnf5
    restorecon -q /usr/lib/sysimage/libdnf5 2>/dev/null || true
fi

# Get transaction description (GUI or CLI command)
desc=$(/usr/local/bin/snapper-desc.sh "$PID")

# Store description for use in POST phase
echo "$desc" > "$STATE_DIR/snapper_desc_${PID}"

# Create PRE snapshot and store snapshot number
pre=$(snapper -c root create -c number -t pre -p -d "$desc") || exit 1

echo "$pre" > "$STATE_DIR/snapper_pre_${PID}"
