#!/bin/bash

set -e

# === Optional user parameter: custom Cursor AppImage URL ===
CUSTOM_URL="$1"
DEFAULT_URL="https://downloads.cursor.com/production/client/linux/x64/appimage/Cursor-0.46.11-ae378be9dc2f5f1a6a1a220c6e25f9f03c8d4e19.deb.glibc2.25-x86_64.AppImage"
APPIMAGE_URL="${CUSTOM_URL:-$DEFAULT_URL}"

# === Paths ===
BASE_DIR="$HOME/apps/cursor"
BIN_DIR="$HOME/bin"
APPIMAGE_PATH="$BASE_DIR/Cursor.AppImage"
WRAPPER_PATH="$BIN_DIR/cursor"
DESKTOP_FILE="$HOME/.local/share/applications/cursor.desktop"
ICON_PATH="$BASE_DIR/cursor-icon.png"

echo "=== Installing Cursor Editor ==="

# Step 1: Prepare directories
echo "[1/5] Preparing directories..."
mkdir -p "$BASE_DIR"
mkdir -p "$BIN_DIR"
mkdir -p "$(dirname "$DESKTOP_FILE")"

# Step 2: Download Cursor AppImage
echo "[2/5] Downloading Cursor AppImage..."
wget -O "$APPIMAGE_PATH" "$APPIMAGE_URL"
chmod +x "$APPIMAGE_PATH"

# Step 3: Create CLI wrapper in ~/bin
echo "[3/5] Creating CLI command cursor (with --no-sandbox)..."
cat <<EOF > "$WRAPPER_PATH"
#!/bin/bash
exec "$APPIMAGE_PATH" --no-sandbox "\$@"
EOF
chmod +x "$WRAPPER_PATH"

# Step 4: Add ~/bin to PATH if not already present
echo "[4/5] Checking PATH..."
if ! echo "$PATH" | grep -q "$HOME/bin"; then
  if ! grep -Fxq 'export PATH="$HOME/bin:$PATH"' "$HOME/.bashrc"; then
    echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
    echo "✅ Added to .bashrc"
  fi
  if ! grep -Fxq 'export PATH="$HOME/bin:$PATH"' "$HOME/.profile"; then
    echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.profile"
    echo "✅ Added to .profile"
  fi
  export PATH="$HOME/bin:$PATH"
  echo "✅ Applied to current session"
else
  echo "✔ ~/bin is already in PATH"
fi

# Step 5: Download icon and create desktop shortcut
echo "[5/5] Creating desktop shortcut..."
if [ ! -f "$ICON_PATH" ]; then
  wget -O "$ICON_PATH" "https://custom.typingmind.com/assets/models/cursor.png"
fi

cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Name=Cursor Editor
Comment=AI Code Editor based on VS Code
Exec=$WRAPPER_PATH %F
Icon=$ICON_PATH
Terminal=false
Type=Application
Categories=Development;IDE;
StartupNotify=true
EOF

update-desktop-database ~/.local/share/applications/ || true

# Done
echo "✅ Installation complete!"
echo "📁 All files are located in: $BASE_DIR"
echo "🚀 Launch from terminal: cursor ."
echo "🖱 Launch from menu: Cursor Editor"
echo "💡 Tested on Ubuntu 24.04 (runs with --no-sandbox)"