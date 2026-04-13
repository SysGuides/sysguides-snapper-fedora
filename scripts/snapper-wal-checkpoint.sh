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

python3 - <<'EOF'
import sqlite3
import time
import sys

DB = "/usr/lib/sysimage/rpm/rpmdb.sqlite"

# Try up to 10 times to checkpoint WAL (single process, no respawn overhead)
for i in range(10):
    try:
        conn = sqlite3.connect(DB, timeout=3)
        conn.execute("PRAGMA busy_timeout=3000")
        result = conn.execute("PRAGMA wal_checkpoint(TRUNCATE)").fetchone()
        conn.close()
        # result[1] = number of remaining frames in WAL (0 = fully flushed)
        if result and result[1] == 0:
            sys.exit(0)
    except sqlite3.OperationalError:
        pass
    time.sleep(0.5)

# Best-effort fallback
sys.exit(1)
EOF
