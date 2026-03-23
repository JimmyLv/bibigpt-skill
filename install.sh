#!/usr/bin/env bash
# BibiGPT Installer — universal install script
# Usage: curl -fsSL https://bibigpt.co/install.sh | bash
set -euo pipefail

LATEST_JSON_CN="https://bibigpt-apps.oss-cn-beijing.aliyuncs.com/desktop-releases/latest.json"
LATEST_JSON_INTL="https://bibigpt-apps.chatvid.ai/desktop-releases/latest.json"
BIN_DIR="${BIBI_INSTALL_DIR:-/usr/local/bin}"

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
    PLATFORM_BLOCK="$(echo "$JSON" | tr -d '\n' | grep -oE "\"$PLATFORM\"\s*:\s*\{[^}]*\}" || true)"
    DOWNLOAD_URL="$(echo "$PLATFORM_BLOCK" | grep -oE '"url"\s*:\s*"[^"]*"' | head -1 | cut -d'"' -f4)"
    [ -n "$VERSION" ] && break
  fi
done

[ -z "$VERSION" ] && err "Failed to fetch version info. Check your network connection."
info "Latest version: $VERSION"

# ── Temp dir & cleanup ───────────────────────────────────────────────
WORK_DIR="$(mktemp -d)"
cleanup() { rm -rf "$WORK_DIR"; }
trap cleanup EXIT

download() {
  local url="$1" dest="$2"
  if [ -n "$url" ]; then
    curl -fL --progress-bar "$url" -o "$dest" || err "Download failed: $url"
  else
    err "No download URL available for $PLATFORM"
  fi
}

# ── macOS ─────────────────────────────────────────────────────────────
if [[ "$OS" == "Darwin" ]]; then
  # Prefer Homebrew if available (manages updates, quarantine, cleanup)
  if command -v brew &>/dev/null; then
    if brew list --cask jimmylv/bibigpt/bibigpt &>/dev/null; then
      info "Upgrading via Homebrew..."
      brew upgrade --cask jimmylv/bibigpt/bibigpt
    else
      info "Installing via Homebrew..."
      brew install --cask jimmylv/bibigpt/bibigpt --force
    fi
    ok "BibiGPT $VERSION installed via Homebrew!"
    echo ""
    echo "  bibi --version          # verify"
    echo "  bibi summarize \"<URL>\"  # summarize a video"
    exit 0
  fi

  # No Homebrew — direct .app install (like Deno, Bun, rustup)
  warn "Homebrew not found, installing directly..."

  FILENAME="BibiGPT-${VERSION}-${PLATFORM}.app.tar.gz"
  TARBALL="${WORK_DIR}/${FILENAME}"

  [ -z "$DOWNLOAD_URL" ] && DOWNLOAD_URL="https://bibigpt-apps.oss-cn-beijing.aliyuncs.com/desktop-releases/${FILENAME}"

  info "Downloading ${FILENAME}..."
  download "$DOWNLOAD_URL" "$TARBALL"

  info "Extracting..."
  tar -xzf "$TARBALL" -C "$WORK_DIR"

  APP_PATH="${WORK_DIR}/BibiGPT.app"
  [ -d "$APP_PATH" ] || err "Extraction failed: BibiGPT.app not found in archive"

  # Remove quarantine flag (download from internet triggers Gatekeeper)
  xattr -rd com.apple.quarantine "$APP_PATH" 2>/dev/null || true

  # Move to /Applications (overwrite if exists)
  DEST="/Applications/BibiGPT.app"
  if [ -d "$DEST" ]; then
    warn "Replacing existing ${DEST}..."
    if [ -w "$DEST" ]; then
      rm -rf "$DEST"
    else
      sudo rm -rf "$DEST"
    fi
  fi
  if [ -w "/Applications" ]; then
    mv "$APP_PATH" "$DEST"
  else
    sudo mv "$APP_PATH" "$DEST"
  fi

  # Symlink CLI binary — same path Homebrew cask uses
  CLI_BIN="${DEST}/Contents/MacOS/BibiGPT"
  if [ -x "$CLI_BIN" ]; then
    info "Creating CLI symlink: ${BIN_DIR}/bibi"
    if [ -w "$BIN_DIR" ] || mkdir -p "$BIN_DIR" 2>/dev/null; then
      ln -sf "$CLI_BIN" "${BIN_DIR}/bibi"
    else
      sudo mkdir -p "$BIN_DIR"
      sudo ln -sf "$CLI_BIN" "${BIN_DIR}/bibi"
    fi
  fi

  ok "BibiGPT $VERSION installed to /Applications/BibiGPT.app"
  echo ""
  echo "  bibi --version          # verify CLI"
  echo "  bibi summarize \"<URL>\"  # summarize a video"
  echo ""
  echo "Tip: Install Homebrew (https://brew.sh) for automatic updates."
  exit 0
fi

# ── Linux: download AppImage ─────────────────────────────────────────
FILENAME="BibiGPT-${VERSION}-${PLATFORM}.AppImage"
TMPFILE="${WORK_DIR}/${FILENAME}"

[ -z "$DOWNLOAD_URL" ] && DOWNLOAD_URL="https://bibigpt-apps.oss-cn-beijing.aliyuncs.com/desktop-releases/${FILENAME}"

info "Downloading ${FILENAME}..."
download "$DOWNLOAD_URL" "$TMPFILE"

chmod +x "$TMPFILE"

info "Installing to ${BIN_DIR}/bibi ..."
sudo mkdir -p "$BIN_DIR"
if [ -w "$BIN_DIR" ]; then
  mv "$TMPFILE" "${BIN_DIR}/bibi"
else
  sudo mv "$TMPFILE" "${BIN_DIR}/bibi"
fi

ok "BibiGPT $VERSION installed successfully!"
echo ""
echo "  bibi --version          # verify"
echo "  bibi summarize \"<URL>\"  # summarize a video"
echo ""
echo "First time? Log in or set your API token:"
echo "  export BIBI_API_TOKEN=<token>  # get one at https://bibigpt.co/settings"
