# Auth, quota, docs

All BibiGPT skills share **one CLI binary** (`bibi`) and **one account**. This skill does not install a second product.

## Docs

- Agent landing (MCP / CLI / API): https://bibigpt.co/mcp
- Human install contracts: https://bibigpt.co/agent
- OpenAPI: https://bibigpt.co/api/openapi.json
- MCP: https://bibigpt.co/api/mcp (Streamable HTTP, OAuth 2.1)

## Auth

| Mode | How |
|------|-----|
| CLI | `bibi auth login` (desktop OAuth) or `bibi auth set-token <TOKEN>` |
| API | `Authorization: Bearer $BIBI_API_TOKEN` from https://bibigpt.co/user/integration |
| MCP | OAuth in the client, or Bearer on `https://bibigpt.co/api/mcp` |

Install the desktop CLI if `command -v bibi` fails: `brew install --cask jimmylv/bibigpt/bibigpt` (macOS), `winget install BibiGPT` (Windows), or `curl -fsSL https://bibigpt.co/install.sh | bash` (Linux).

## Quota

On the agent-skill / MCP / CLI channel: **Plus 100 calls/day**, **Pro 300 calls/day**. Extra calls use API balance. Web-app membership quota is separate. Upgrade: https://bibigpt.co/shop

`extract_video_visuals` / `bibi video visuals` is **Pro-only** and rate-limited. Mindmap generation uses the same account.

HTTP 402 / `[HTTP/402 Payment Required]` → send the user to https://bibigpt.co/shop
