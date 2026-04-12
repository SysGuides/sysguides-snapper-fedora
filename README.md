# SysGuides Snapper Setup for Fedora

Automated Snapper + grub-btrfs setup for Fedora, including a WAL fix for libdnf5 (DNF5) to ensure proper snapshot rollback after the switch of PackageKit to the DNF5 backend in Fedora 44.

---

## ✨ Features

- One-command installation (`./install.sh`)
- Full Snapper setup for:
  - Root (`/`)
  - Home (`/home`)
- Integration with DNF5 (CLI + GUI)
- Automatic pre/post snapshots for package transactions
- Clean snapshot descriptions:
  - CLI → actual command (e.g. `dnf install vim`)
  - GUI → simplified (e.g. `GUI install firefox`)
- Fix for RPM database inconsistency (SQLite WAL issue)
- grub-btrfs integration for booting into snapshots
- Automatic GRUB updates
- Sensible defaults (no unnecessary home timeline snapshots)

---

## ⚠️ Compatibility

- Tested on:
  - Fedora Workstation (GNOME)
  - Fedora KDE Spin

> Other Fedora spins may work, but are not explicitly tested.

---

## 🚀 Installation

```bash
git clone https://github.com/SysGuides/sysguides-snapper-fedora
cd sysguides-snapper-fedora
chmod +x install.sh
./install.sh
