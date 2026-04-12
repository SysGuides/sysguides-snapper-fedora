#!/usr/bin/env bash

# snapper-wal-checkpoint.sh
# --------------------------
# Forces an SQLite WAL checkpoint for the RPM database used by libdnf5.
#
# Fedora 44 introduced DNF5 (libdnf5), which uses SQLite with WAL mode.
# This can lead to inconsistencies during snapper undochange, where:
# - Files are reverted correctly
# - But the RPM database still reports packages as installed
#
# This script attempts to flush WAL data to the main database file
# before the POST snapshot is created.
#
# The operation is best-effort:
# - Retries multiple times if the database is busy
# - Fails silently if unable to complete
#
# Project: sysguides-snapper-fedora
# Author: Madhu Desai (SysGuides)
# Website: https://sysguides.com
# GitHub: https://github.com/SysGuides/sysguides-snapper-fedora

DB="/usr/lib/sysimage/rpm/rpmdb.sqlite"

# Try up to 10 times to checkpoint WAL
for i in {1..10}; do
    python3 - <<EOF
import sqlite3
import sys

try:
    conn = sqlite3.connect("$DB", timeout=3)
    conn.execute("PRAGMA busy_timeout=3000")
    result = conn.execute("PRAGMA wal_checkpoint(TRUNCATE)").fetchone()
    conn.close()

    # result[1] = number of remaining frames in WAL
    if result and result[1] == 0:
        sys.exit(0)
except:
    pass

sys.exit(1)
EOF

    # If checkpoint succeeded, exit
    if [ $? -eq 0 ]; then
        exit 0
    fi

    sleep 1
done

# Best-effort fallback
exit 1
