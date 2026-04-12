#!/usr/bin/env bash

# snapper-desc.sh
# ----------------
# Determines a human-readable description for the transaction.
#
# This script inspects the process that triggered the DNF5 transaction.
#
# Behavior:
# - If the transaction originates from GUI tools (PackageKit / dnf5daemon),
#   it returns "GUI"
# - Otherwise, it returns the actual command (e.g., "dnf install vim")
#
# This description is later used by Snapper for snapshot naming.
#
# Project: sysguides-snapper-fedora
# Author: Madhu Desai (SysGuides)
# Website: https://sysguides.com
# GitHub: https://github.com/SysGuides/sysguides-snapper-fedora

PID="$1"

# Get the full command of the originating process
cmd=$(ps -o command --no-headers -p "$PID" 2>/dev/null || echo "Unknown Task")

case "$cmd" in
    */dnf5daemon* | */packagekitd*)
        # GUI-based transaction
        echo "GUI"
        ;;
    *)
        # CLI or unknown source
        echo "$cmd"
        ;;
esac
