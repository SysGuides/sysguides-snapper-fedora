#!/usr/bin/env bash

# snapper-gui-pkg.sh
# ------------------
# Captures the first package involved in a GUI-based transaction.
#
# This script:
# - Runs during DNF5 transaction events (pre_transaction hooks)
# - Detects if the transaction originated from a GUI
# - Records the first package name and action (install/remove)
#
# This allows snapshots to have meaningful descriptions like:
#   "GUI install firefox"
#
# Only the first package is recorded to keep descriptions concise.
#
# Project: sysguides-snapper-fedora
# Author: Madhu Desai (SysGuides)
# Website: https://sysguides.com
# GitHub: https://github.com/SysGuides/sysguides-snapper-fedora

PID="$1"
ACTION="$2"
NAME="$3"

STATE_DIR="/run/snapper-actions"
DESC_FILE="$STATE_DIR/snapper_desc_${PID}"
PKG_FILE="$STATE_DIR/snapper_gui_${PID}"

# Read previously stored description (set in PRE phase)
desc=$(cat "$DESC_FILE" 2>/dev/null || echo "")

# Only proceed if this is a GUI transaction
[[ "$desc" != "GUI" ]] && exit 0

# Only capture the first package to avoid overwriting
[[ -f "$PKG_FILE" ]] && exit 0

# Determine action type and store description
case "$ACTION" in
    I|U|D|R)
        # Install / upgrade / downgrade / reinstall
        echo "GUI install ${NAME}" > "$PKG_FILE"
        ;;
    E|O)
        # Erase / obsolete
        echo "GUI remove ${NAME}" > "$PKG_FILE"
        ;;
esac
