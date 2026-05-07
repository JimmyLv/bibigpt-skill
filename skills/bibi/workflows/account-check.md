# Workflow: Account & Quota Check

Use this when the user asks about their BibiGPT plan, member status, or remaining summarization minutes.

## Triggers

- "What's my plan?"
- "How many minutes do I have left?"
- "Am I a Pro member?"
- "我还剩多少分钟？"
- "我的账户是什么套餐？"
- "查询我的剩余额度"
- "Show my BibiGPT account info"

## Environment Check

Run `scripts/bibi-check.sh` to confirm CLI or API mode is available. Authentication is required (this is per-user data).

## Steps

### CLI mode (preferred)

```bash
bibi me --json
```

Output (example):
```json
{
  "userId": "...",
  "email": "...",
  "plan": {
    "tier": "pro",
    "isPaidMember": true,
    "expiresAt": "2027-01-15T00:00:00.000Z"
  },
  "remainingMinutes": 1280
}
```

### API mode

```bash
curl -H "Authorization: Bearer $BIBI_API_TOKEN" \
  https://bibigpt.co/api/v1/me
```

Same JSON shape as CLI.

## Output formatting

Present the result conversationally:

> 你目前是 **Pro 会员**，到期时间 2027-01-15，剩余 **1280 分钟**。

For free users, suggest the upgrade page if they're running low:

> 你是免费用户，剩余 12 分钟。如需更多时长，可访问 https://bibigpt.co/shop?onDemand=true 升级或购买时长。

## Error handling

- **401 Unauthorized**: Run `bibi auth check` then `bibi auth login` (CLI) or set `BIBI_API_TOKEN` (API).
- **Network error**: Check connection; the endpoint is `https://bibigpt.co/api/v1/me`.

## Plan tiers

| Tier | Meaning |
|------|---------|
| `free` | Free user, limited daily quota |
| `plus` | Plus subscription |
| `pro` | Pro subscription (most features unlocked) |
| `lifetime` | Lifetime purchase (`expiresAt` 10+ years out) |
