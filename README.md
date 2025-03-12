# Cursor Installer for Ubuntu

## 📂 Description
This script automates the installation of the Cursor AI Code Editor (based on VS Code) on Ubuntu systems.

It will:
- Download the latest or specified version of Cursor AppImage;
- Place everything in `~/apps/cursor`;
- Create a CLI wrapper command `cursor` in `~/bin/`;
- Add a menu launcher (desktop shortcut) with a high-quality icon.

> ✅ Tested on Ubuntu 24.04

---

## 🚀 Installation

```bash
chmod +x install-cursor.sh
./install-cursor.sh
```

You can also pass a custom Cursor AppImage URL:

```bash
./install-cursor.sh "https://downloads.cursor.com/production/client/linux/x64/appimage/Cursor-0.46.11-...AppImage"
```

---

## ✅ After Installation
- All files are stored in: `~/apps/cursor`
- CLI command: `cursor`
- Menu entry: **Cursor Editor**

---

## ⚠ About sandbox mode
Cursor is based on Electron and uses Chromium's sandboxing mechanism. However, in many AppImage builds (including Cursor), full sandboxing may fail even on a regular Ubuntu system due to how the application is packaged.

This installer intentionally runs Cursor with the `--no-sandbox` flag to ensure consistent and stable execution. This is a common practice for Electron-based AppImages and does not affect normal usage for local development.

If the Cursor team improves sandbox compatibility in future builds, you may remove `--no-sandbox` from the launcher script.

---

## 🔧 Requirements
- Ubuntu (20.04 / 22.04 / 24.04+)
- `wget`, `update-desktop-database`

---

## 📄 License
This script is distributed under the MIT License.