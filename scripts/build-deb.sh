#!/bin/bash
set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VERSION="0.1.0"
DEB_DIR="$ROOT/dist/deb"
OUT="$ROOT/dist/synarch_${VERSION}_amd64.deb"

# Limpiar y crear estructura
rm -rf "$DEB_DIR" "$OUT"
mkdir -p "$DEB_DIR"/{DEBIAN,opt/synarch,usr/share/applications,usr/share/pixmaps,usr/bin}

# Copiar binarios
cp -a "$ROOT/dist/linux/"* "$DEB_DIR/opt/synarch/"

# Control
cat > "$DEB_DIR/DEBIAN/control" <<EOF
Package: synarch
Version: $VERSION
Section: web
Priority: optional
Architecture: amd64
Depends: libgtk-3-0, libnotify4, libnss3, libxss1, libxtst6, xdg-utils, libatspi2.0-0, libsecret-1-0
Maintainer: Carlos Barca <carlos@synarch.app>
Description: Synarch - Multi AI Chat
 Desktop application with tabbed webviews for multiple AI chat platforms
 including ChatGPT, Claude, Gemini, Grok, DeepSeek, Copilot, Perplexity
 and Mistral.
EOF

# Desktop entry
cat > "$DEB_DIR/usr/share/applications/synarch.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Synarch
Comment=Multi AI Chat Platform
Exec=/opt/synarch/synarch
Icon=synarch
Path=/opt/synarch
Terminal=false
Categories=Network;Chat;
EOF

# Logo e icono
cp "$ROOT/logo-synarch.svg" "$DEB_DIR/usr/share/pixmaps/synarch.svg"

# Symlink en PATH
ln -s /opt/synarch/synarch "$DEB_DIR/usr/bin/synarch"

# Optimización: Eliminar locales innecesarios (ahorra ~100MB)
echo "Optimizando locales..."
find "$DEB_DIR/opt/synarch/locales" -type f ! -name "es.pak" ! -name "en-US.pak" -delete

# Generar .deb con compresión máxima (xz)
echo "Generando paquete .deb con compresión xz..."
dpkg-deb -Zxz --build "$DEB_DIR" "$OUT"
echo "Paquete generado: $OUT"
