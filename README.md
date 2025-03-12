## 📘 Cursor Installer for Ubuntu

### 📂 Description
This script automates the installation of the Cursor AI Code Editor (based on VS Code) on Ubuntu systems.

It will:
- Download the latest or specified version of Cursor AppImage;
- Setup `chrome-sandbox` (from system or via downloading Google Chrome `.deb`);
- Place everything in `~/apps/cursor`;
- Create a CLI wrapper command `cursor` in `~/bin/`;
- Add menu launcher (desktop shortcut) with a high-quality icon.

> ✅ Tested on Ubuntu 24.04

---

### 🚀 Installation

```bash
chmod +x install-cursor.sh
./install-cursor.sh
```

You can also pass a custom Cursor AppImage URL:

```bash
./install-cursor.sh "https://downloads.cursor.com/production/client/linux/x64/appimage/Cursor-0.46.11-...AppImage"
```

---

### ✅ After Installation
- All files: `~/apps/cursor`
- CLI command: `cursor`
- Menu entry: **Cursor Editor**

---

### 🔧 Requirements
- Ubuntu (20.04, 22.04, 24.04+)
- `wget`, `dpkg`, `update-desktop-database`
- System-installed Google Chrome (optional, for sandbox)

If Chrome is not installed, the script will automatically download and extract `chrome-sandbox`.