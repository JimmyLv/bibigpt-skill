# Billing via Alipay AI收 (402 Payment Required)

BibiGPT supports the [Alipay AI收 protocol](https://opendocs.alipay.com/open/repo-041mh0)
for per-call agent payments. This is an HTTP-402-based standard (similar to
the [x402 protocol](https://www.x402.org/)) that lets an agent autonomously
pay for an API call without the user needing a BibiGPT subscription.

This is a **fallback channel** — if `BIBI_API_TOKEN` is set or the user is
a BibiGPT member, calls go through the existing subscription / quota path
and no 402 is emitted.

## When 402 happens

A call returns HTTP `402 Payment Required` only if **all** of these are true:

1. The route opted in to AI 收 (currently `POST /v1/summarize`; more endpoints
   roll out one at a time)
2. The call came in via the `agent-skill` channel (i.e., `x-client-type: bibi-cli`
   or the MCP server)
3. The caller has no active subscription / API token / free-quota credit

The response includes a `Payment-Needed` HTTP header (base64url-encoded JSON)
that names the price, the resource being charged for, and the seller's
signed challenge. The bibi CLI prints `[HTTP/402 Payment Required]` to stderr
before the human-readable prompt — agent skills can grep for it to detect 402
deterministically.

## What the agent should do

### Option 1 — automated via Alipay AI 钱包 skill (recommended)

If your agent has `@alipay/agent-payment` installed, payment is automatic:

```bash
npx -y @alipay/agent-payment@latest install
```

After install, the agent will:
1. See the 402, ask the user to authorize via Alipay (one-time push or scan)
2. Retry the original BibiGPT call with a `Payment-Proof` header
3. BibiGPT verifies the proof via `alipay.aipay.agent.payment.verify`
4. Returns the resource and confirms fulfillment with Alipay

User experience: roughly **one Alipay approval per API call** (≈ ¥1).

### Option 2 — manual (any agent)

If `@alipay/agent-payment` is not installed, the bibi CLI prints a prompt:

```
── 此次调用需要支付 ────────────────────────
  金额:     ¥1.00 (CNY)
  商品:     YouTube 视频总结
  卖家:     BibiGPT
  ...
```

Guide the user to:
- Visit `https://bibigpt.co/shop?onDemand=true` for a one-off purchase, **or**
- Install `@alipay/agent-payment` and retry

## Detecting 402 from CLI output

The bibi CLI emits a stable marker line to stderr ahead of any human prompt:

```
[HTTP/402 Payment Required]
```

If an agent skill sees this line on stderr (or HTTP 402 from a direct API
call), it should switch to the Alipay-AI-钱包 flow above. The marker appears
on every code path that yields 402 — direct summarize, chapter, subtitle,
async, and the generic `bibi call` dispatcher.

## Caveats

- **Trial-period limits**: 个人商家 ≤ ¥50 / call, ≤ ¥1000 / day. Most BibiGPT
  endpoints are priced ≤ ¥3 so this rarely matters.
- **No sandbox**: integration must be tested with real money (¥0.01 minimum).
- **CNY only** (mainland China). International users should keep using
  `BIBI_API_TOKEN` (subscription) for now.

## Pricing snapshot (subject to change)

| Endpoint | Default price |
|---|---|
| `/v1/summarize` | ¥1.00 / call |
| `/v1/summarizeByChapter` | ¥3.00 / call |
| `/v1/generateSummaryByPrompt` | ¥1.00 / call |
| `/v1/generateVideoMindmap` | ¥5.00 / call |

Free for individual developers from 2026-04-15 through 2026-12-31 (Alipay
zero-fee promo); 1% fee thereafter.

## Troubleshooting

| Error code (Payment-Proof verify) | Meaning | Fix |
|---|---|---|
| `PAYMENT_PROOF_NOT_FOUND` | Proof expired or invalid | Re-pay |
| `PAYMENT_PROOF_BUYER_MISMATCH` | Different user paid | Each agent must pay its own way |
| `PAYMENT_PROOF_STATUS_INVALID` | Proof already consumed | Re-pay (no double-spend) |
| `CLIENT_SESSION_IS_EMPTY` | agent CLI version too old | Upgrade `@alipay/agent-payment` |
| `TRADE_STATUS_UNPAID` | User hasn't completed payment yet | Wait + retry |
