#!/usr/bin/env bash
# Detect available BibiGPT mode: CLI or OpenAPI

if command -v bibi &>/dev/null; then
  echo "✓ bibi CLI found: $(bibi --version 2>/dev/null || echo 'unknown version')"
  echo "Mode: CLI — use 'bibi summarize <URL>' commands."
elif [ -n "$BIBI_API_TOKEN" ]; then
  echo "✓ BIBI_API_TOKEN is set (CLI not installed)."
  echo "Mode: OpenAPI — call https://api.bibigpt.co/api/v1/ endpoints with curl."
  echo ""
  echo "Quick test:"
  echo '  curl -sf "https://api.bibigpt.co/api/version" -H "Authorization: Bearer $BIBI_API_TOKEN"'
else
  echo "bibi CLI not found and BIBI_API_TOKEN is not set."
  echo ""
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Option 1 (CLI): brew install --cask jimmylv/bibigpt/bibigpt"
  elif [[ "$OSTYPE" == "msys"* || "$OSTYPE" == "cygwin"* ]]; then
    echo "Option 1 (CLI): winget install BibiGPT --source winget"
  elif [[ "$OSTYPE" == "linux"* ]]; then
    echo "Option 1 (CLI): curl -fsSL https://bibigpt.co/install.sh | bash"
  else
    echo "Option 1 (CLI): Visit https://bibigpt.co/download/desktop"
  fi
  echo "Option 2 (OpenAPI): export BIBI_API_TOKEN=<token>  # get token at https://bibigpt.co/user/integration"
  echo ""
  echo "See SKILL.md for full usage instructions."
  exit 1
fi
