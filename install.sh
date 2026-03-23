#!/usr/bin/env bash
# BibiGPT Installer — universal install script
# Usage: curl -fsSL https://bibigpt.co/install.sh | bash
set -euo pipefail

LATEST_JSON_CN="https://bibigpt-apps.oss-cn-beijing.aliyuncs.com/desktop-releases/latest.json"
LATEST_JSON_INTL="https://bibigpt-apps.chatvid.ai/desktop-releases/latest.json"

info()  { printf '\033[1;34m%s\033[0m\n' "$*"; }
ok()    { printf '\033[1;32m%s\033[0m\n' "$*"; }
warn()  { printf '\033[1;33m%s\033[0m\n' "$*"; }
err()   { printf '\033[1;31mError: %s\033[0m\n' "$*" >&2; exit 1; }

# ── Detect OS & arch ──────────────────────────────────────────────────
OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
  Darwin)
    case "$ARCH" in
      arm64)  PLATFORM="darwin-aarch64" ;;
      x86_64) PLATFORM="darwin-x86_64" ;;
      *) err "Unsupported macOS architecture: $ARCH" ;;
    esac
    ;;
  Linux)
    case "$ARCH" in
      x86_64|amd64) PLATFORM="linux-x86_64" ;;
      *) err "Unsupported Linux architecture: $ARCH (only x86_64 is supported)" ;;
    esac
    ;;
  MINGW*|MSYS*|CYGWIN*)
    err "On Windows, use: winget install BibiGPT --source winget"
    ;;
  *) err "Unsupported OS: $OS" ;;
esac

info "Detected platform: $PLATFORM"

# ── Fetch latest version ─────────────────────────────────────────────
info "Fetching latest version info..."

VERSION=""
DOWNLOAD_URL=""
for json_url in "$LATEST_JSON_CN" "$LATEST_JSON_INTL"; do
  JSON="$(curl -sf --connect-timeout 5 "$json_url" 2>/dev/null || true)"
  if [ -n "$JSON" ]; then
    VERSION="$(echo "$JSON" | grep -oE '"version"\s*:\s*"[^"]*"' | head -1 | cut -d'"' -f4)"
    # Extract platform block (handles pretty-printed JSON by collapsing whitespace)
    PLATFORM_BLOCK="$(echo "$JSON" | tr -d '\n' | grep -oE "\"$PLATFORM\"\s*:\s*\{[^}]*\}" || true)"
    DOWNLOAD_URL="$(echo "$PLATFORM_BLOCK" | grep -oE '"url"\s*:\s*"[^"]*"' | head -1 | cut -d'"' -f4)"
    [ -n "$VERSION" ] && break
  fi
done

[ -z "$VERSION" ] && err "Failed to fetch version info. Check your network connection."
info "Latest version: $VERSION"

# ── macOS: install via Homebrew ───────────────────────────────────────
if [[ "$OS" == "Darwin" ]]; then
  if command -v brew &>/dev/null; then
    if brew list --cask jimmylv/bibigpt/bibigpt &>/dev/null; then
      info "Upgrading via Homebrew..."
      brew upgrade --cask jimmylv/bibigpt/bibigpt
    else
      info "Installing via Homebrew..."
      brew install --cask jimmylv/bibigpt/bibigpt --force
    fi
    ok "BibiGPT installed via Homebrew!"
    echo ""
    echo "  bibi --version          # verify installation"
    echo "  bibi summarize \"<URL>\"  # summarize a video"
    exit 0
  else
    err "Homebrew not found. Install it first: https://brew.sh"
  fi
fi

# ── Linux: download AppImage ─────────────────────────────────────────
INSTALL_DIR="${BIBI_INSTALL_DIR:-/usr/local/bin}"
FILENAME="BibiGPT-${VERSION}-${PLATFORM}.AppImage"
TMPDIR="$(mktemp -d)"
TMPFILE="${TMPDIR}/${FILENAME}"

cleanup() { rm -rf "$TMPDIR"; }
trap cleanup EXIT

if [ -n "$DOWNLOAD_URL" ]; then
  info "Downloading ${FILENAME}..."
  curl -fL --progress-bar "$DOWNLOAD_URL" -o "$TMPFILE" || err "Download failed from: $DOWNLOAD_URL"
else
  FALLBACK_URL="https://bibigpt-apps.oss-cn-beijing.aliyuncs.com/desktop-releases/${FILENAME}"
  info "Downloading ${FILENAME}..."
  curl -fL --progress-bar "$FALLBACK_URL" -o "$TMPFILE" || err "Download failed from: $FALLBACK_URL"
fi

chmod +x "$TMPFILE"

info "Installing to ${INSTALL_DIR}/bibi ..."
if [ -w "$INSTALL_DIR" ]; then
  mv "$TMPFILE" "${INSTALL_DIR}/bibi"
else
  sudo mv "$TMPFILE" "${INSTALL_DIR}/bibi"
fi

ok "BibiGPT $VERSION installed successfully!"
echo ""
echo "  bibi --version          # verify installation"
echo "  bibi summarize \"<URL>\"  # summarize a video"
echo ""
echo "First time? Log in or set your API token:"
echo "  export BIBI_API_TOKEN=<token>  # get one at https://bibigpt.co/settings"
