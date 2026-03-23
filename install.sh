#!/usr/bin/env bash
# BibiGPT Installer — cross-platform install script
# Usage: curl -fsSL https://bibigpt.co/install.sh | bash
set -euo pipefail

LATEST_JSON_CN="https://bibigpt-apps.oss-cn-beijing.aliyuncs.com/desktop-releases/latest.json"
LATEST_JSON_INTL="https://bibigpt-apps.chatvid.ai/desktop-releases/latest.json"
INSTALL_DIR="${BIBI_INSTALL_DIR:-/usr/local/bin}"

info()  { printf '\033[1;34m%s\033[0m\n' "$*"; }
ok()    { printf '\033[1;32m%s\033[0m\n' "$*"; }
err()   { printf '\033[1;31mError: %s\033[0m\n' "$*" >&2; exit 1; }

# ── Detect OS & arch ──────────────────────────────────────────────────
OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
  Darwin)
    info "Detected macOS — use Homebrew instead:"
    echo "  brew install --cask jimmylv/bibigpt/bibigpt"
    exit 0
    ;;
  Linux) ;;
  MINGW*|MSYS*|CYGWIN*)
    info "Detected Windows — use winget instead:"
    echo "  winget install BibiGPT --source winget"
    exit 0
    ;;
  *) err "Unsupported OS: $OS" ;;
esac

case "$ARCH" in
  x86_64|amd64) PLATFORM="linux-x86_64" ;;
  *) err "Unsupported architecture: $ARCH (only x86_64 is supported)" ;;
esac

# ── Fetch latest version ─────────────────────────────────────────────
info "Fetching latest version info..."

VERSION=""
DOWNLOAD_URL=""
for url in "$LATEST_JSON_CN" "$LATEST_JSON_INTL"; do
  JSON="$(curl -sf --connect-timeout 5 "$url" 2>/dev/null || true)"
  if [ -n "$JSON" ]; then
    VERSION="$(echo "$JSON" | grep -o '"version":"[^"]*"' | head -1 | cut -d'"' -f4)"
    # Try to extract platform-specific URL from latest.json
    DOWNLOAD_URL="$(echo "$JSON" | grep -o "\"$PLATFORM\":{[^}]*}" | grep -o '"url":"[^"]*"' | head -1 | cut -d'"' -f4)"
    [ -n "$VERSION" ] && break
  fi
done

[ -z "$VERSION" ] && err "Failed to fetch version info. Check your network connection."

info "Latest version: $VERSION"

# ── Download AppImage ─────────────────────────────────────────────────
FILENAME="BibiGPT-${VERSION}-${PLATFORM}.AppImage"
TMPDIR="$(mktemp -d)"
TMPFILE="${TMPDIR}/${FILENAME}"

cleanup() { rm -rf "$TMPDIR"; }
trap cleanup EXIT

if [ -n "$DOWNLOAD_URL" ]; then
  info "Downloading ${FILENAME}..."
  curl -fL --progress-bar "$DOWNLOAD_URL" -o "$TMPFILE" || err "Download failed from: $DOWNLOAD_URL"
else
  # Fallback: construct URL from known pattern
  FALLBACK_URL="https://bibigpt-apps.oss-cn-beijing.aliyuncs.com/desktop-releases/${FILENAME}"
  info "Downloading ${FILENAME}..."
  curl -fL --progress-bar "$FALLBACK_URL" -o "$TMPFILE" || err "Download failed from: $FALLBACK_URL"
fi

chmod +x "$TMPFILE"

# ── Install ───────────────────────────────────────────────────────────
info "Installing to ${INSTALL_DIR}/bibi ..."

if [ -w "$INSTALL_DIR" ]; then
  mv "$TMPFILE" "${INSTALL_DIR}/bibi"
else
  sudo mv "$TMPFILE" "${INSTALL_DIR}/bibi"
fi

ok "BibiGPT $VERSION installed successfully!"
echo ""
echo "  bibi --version     # verify installation"
echo "  bibi summarize \"<URL>\"  # summarize a video"
echo ""
echo "First time? Log in or set your API token:"
echo "  export BIBI_API_TOKEN=<token>  # get one at https://bibigpt.co/settings"
