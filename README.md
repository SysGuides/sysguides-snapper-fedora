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

## 📺 Full Setup Guide

Follow the complete setup:

- 🌐 Article  
  👉 https://sysguides.com  
- 📺 YouTube  
  👉 https://youtube.com/@SysGuides  

---

## ⚠️ Compatibility

- Tested on:
  - Fedora Workstation (GNOME)
  - Fedora KDE Spin

### ✅ Recommended Setup

Works best with:

- 🌐 SysGuides Fedora Btrfs + Snapper installation guide  
  👉 https://sysguides.com  
- 📺 YouTube walkthrough  
  👉 https://youtube.com/@SysGuides  

✔ Full compatibility (including `/boot` rollback)

---

> ⚠️ **Note on default Fedora installations**
>
> This setup also works on the default Fedora Btrfs layout.  
> However:
>
> - `/boot` is not on Btrfs  
> - Kernel rollback is **not fully supported**  
> - Snapshots restore the root filesystem, but not `/boot`
>
> For full rollback capability, follow the SysGuides setup.

---

## 🚀 Installation

```bash
git clone https://github.com/SysGuides/sysguides-snapper-fedora
cd sysguides-snapper-fedora
chmod +x install.sh
./install.sh
