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
SANDBOX_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
SANDBOX_DEB="$BASE_DIR/google-chrome.deb"
SANDBOX_PATH="$BASE_DIR/chrome-sandbox"
WRAPPER_PATH="$BIN_DIR/cursor"
TEMP_DIR="$BASE_DIR/tmp-chrome"
DESKTOP_FILE="$HOME/.local/share/applications/cursor.desktop"
ICON_PATH="$BASE_DIR/cursor-icon.png"

echo "=== Installing Cursor Editor ==="

# Step 1: Prepare directories
echo "[1/7] Preparing directories..."
mkdir -p "$BASE_DIR"
mkdir -p "$BIN_DIR"
mkdir -p "$(dirname "$DESKTOP_FILE")"

# Step 2: Download Cursor AppImage
echo "[2/7] Downloading Cursor AppImage..."
wget -O "$APPIMAGE_PATH" "$APPIMAGE_URL"
chmod +x "$APPIMAGE_PATH"

# Step 3: Setup chrome-sandbox
echo "[3/7] Setting up chrome-sandbox..."
if [ -f "/opt/google/chrome/chrome-sandbox" ]; then
  echo "✔ Using system chrome-sandbox from /opt/google/chrome/"
  cp /opt/google/chrome/chrome-sandbox "$SANDBOX_PATH"
  chmod 4755 "$SANDBOX_PATH"
else
  echo "⚠ System chrome-sandbox not found, downloading Google Chrome .deb..."
  wget -O "$SANDBOX_DEB" "$SANDBOX_URL"
  mkdir -p "$TEMP_DIR"
  dpkg-deb -x "$SANDBOX_DEB" "$TEMP_DIR"
  cp "$TEMP_DIR/opt/google/chrome/chrome-sandbox" "$SANDBOX_PATH"
  chmod 4755 "$SANDBOX_PATH"
  rm -rf "$TEMP_DIR" "$SANDBOX_DEB"
fi

# Step 4: Create CLI wrapper in ~/bin
echo "[4/7] Creating CLI command cursor..."
cat <<EOF > "$WRAPPER_PATH"
#!/bin/bash
export CHROME_DEVEL_SANDBOX="$SANDBOX_PATH"
exec "$APPIMAGE_PATH" "\$@"
EOF
chmod +x "$WRAPPER_PATH"

# Step 5: Add ~/bin to PATH if not already present
echo "[5/7] Checking PATH..."
if ! echo "$PATH" | grep -q "$HOME/bin"; then
  echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
  echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.profile"
  echo "✅ Added ~/bin to PATH. Run: source ~/.bashrc"
fi

# Step 6: Download icon
echo "[6/7] Downloading icon..."
if [ ! -f "$ICON_PATH" ]; then
  wget -O "$ICON_PATH" "https://custom.typingmind.com/assets/models/cursor.png"
else
  echo "📁 Icon already exists, skipping download."
fi

# Step 7: Create desktop entry
echo "[7/7] Creating desktop shortcut..."
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