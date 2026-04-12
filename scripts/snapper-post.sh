#!/usr/bin/env bash

# snapper-post.sh
# ----------------
# Creates a POST snapshot after a DNF5 transaction completes.
#
# This script:
# - Retrieves stored PRE snapshot and description
# - Improves description using GUI package info (if available)
# - Applies SQLite WAL checkpoint fix for libdnf5
# - Creates the POST snapshot linked to the PRE snapshot
# - Cleans up temporary state files
#
# The WAL checkpoint is necessary on Fedora 44+ to reduce
# inconsistencies between filesystem state and RPM database.
#
# Project: sysguides-snapper-fedora
# Author: Madhu Desai (SysGuides)
# Website: https://sysguides.com
# GitHub: https://github.com/SysGuides/sysguides-snapper-fedora

PID="$1"
STATE_DIR="/run/snapper-actions"

DESC_FILE="$STATE_DIR/snapper_desc_${PID}"
PRE_FILE="$STATE_DIR/snapper_pre_${PID}"
GUI_FILE="$STATE_DIR/snapper_gui_${PID}"

# Load stored state (if available)
desc=$(cat "$DESC_FILE" 2>/dev/null || echo "")
pre=$(cat "$PRE_FILE" 2>/dev/null || echo "")
gui_pkg=$(cat "$GUI_FILE" 2>/dev/null || echo "")

# If no PRE snapshot exists, nothing to do
[[ -z "$pre" ]] && exit 0

# If GUI package info exists, improve snapshot description
if [[ -n "$gui_pkg" ]]; then
    desc="$gui_pkg"
    snapper -c root modify -d "$desc" "$pre" || true
fi

# Apply WAL checkpoint (best-effort; do not fail if it doesn't succeed)
/usr/local/bin/snapper-wal-checkpoint.sh || true

# Create POST snapshot linked to PRE snapshot
snapper -c root create -c number -t post \
    --pre-number "$pre" -d "$desc"

# Clean up temporary state files
rm -f "$DESC_FILE" "$PRE_FILE" "$GUI_FILE"
