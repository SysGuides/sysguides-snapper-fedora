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

### ✅ Recommended Setup

Works best with:

- 🌐 [How to Setup Fedora 44 with Btrfs Snapshot and Rollback Support](https://sysguides.com/fedora-44-with-btrfs-snapshot-and-rollback-support)
- 📺 [Never Break Fedora 44 Again! Complete Snapper & Rollback Guide](https://youtu.be/d-CafjZf2M4) (YouTube walkthrough)

✔ Full compatibility (including `/boot` rollback)

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
```

---

## 🚀 Basic Usage

### Automatic snapshots with DNF

This setup works with:

- DNF5 command line (`dnf`)
- GNOME Software
- KDE Plasma Discover

This is possible because Fedora 44 switches PackageKit to the new DNF5 backend built on libdnf5, allowing proper Snapper integration for both CLI and GUI package management.

In this example, we use `htop` as a sample package and assume the PRE and POST snapshot numbers created are `1` and `2`.

This installs the package and automatically creates PRE and POST snapshots.

```bash
sudo dnf install htop
```

This shows the filesystem changes between snapshot `1` (PRE) and snapshot `2` (POST).

```bash
snapper status 1..2
```

This reverts all filesystem changes made between those two snapshots.

```bash
sudo snapper undochange 1..2
```

This restores only the specific file `/etc/hosts` from snapshot `2` to the current system, where `0` represents the current live state.

```bash
sudo snapper undochange 2..0 /etc/hosts
```

### Manual PRE and POST snapshots

This is best used when manually testing something important and you want a clean way to revert everything afterward.

This creates a restore point before starting your testing.

```bash
snapper -c root create -t pre -c number -d "Pre test"
snapper -c home create -t pre -c number -d "Pre test"
```

Do all your testing.

This creates the matching POST snapshots linked to the PRE snapshots.

```bash
snapper -c root create -t post --pre-number <pre-number> -c number -d "Post test"
snapper -c home create -t post --pre-number <pre-number> -c number -d "Post test"
```

This shows all available snapshots for both root and home.

```bash
snapper -c root ls
snapper -c home ls
```

This restores both system files and application/user state back to the previous clean state.

```bash
sudo snapper -c root undochange <pre>..<post>
sudo snapper -c home undochange <pre>..<post>
```

### Full rollback using grub-btrfs

1. Reboot the system  
2. From the GRUB menu, boot into the snapshot you want to restore  
3. Open Btrfs Assistant  
4. Click Restore / Rollback

This is useful when the system no longer boots correctly or when a full system rollback is needed.
