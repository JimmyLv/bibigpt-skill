# bibigpt-skill (External Agent Contract)

## Audience

这个 package 的内容会被**外部 Agent**（Claude / Cursor / OpenClaw / Cline / 通义灵码 等）当 skill 加载，是 BibiGPT **对外的契约文档**。**不是** BibiGPT 团队内部的状态板。

## Hard No

写入 `skills/**/*.md` / `references/*.md` 时，**禁止**包含：

- 我们 BibiGPT 的内部 ID（支付宝 APPID、service_id、seller_id、合约号、user_id 等）
- 部署状态、灰度阶段、smoke test 结果、上线时间表
- 服务端 env var 名（`ALIPAY_*` / `BIBI_*` 之类）
- 内部 commit 号、PR 链接、issue 编号
- 团队内部决策记录（"待 X 后切换"等）

**Why**：agent 不关心我们什么时候上线、是不是已经联调通过；agent 关心**它怎么调、收到啥怎么处理、错了怎么 retry**。把内部状态塞进去 = 给竞品/逆向人员送情报，也污染了 agent 的上下文。

**这些信息归宿**：根仓 `notes/`（团队工作沉淀）+ Claude memory（跨会话状态）。

## Hard Yes

写入应当：

- 描述 **agent 的行为契约**：endpoint、参数、出参 shape、错误码、retry 策略
- 提供 **agent 给用户的提示话术模板**（如 402 提示）
- 给出 **触发意图**（什么样的用户问题该调这个工具）
- 写**通用价位区间**（"≤ ¥5 / call"），不写**具体数字**（容易过期）

## 同步规则

新增 / 修改 BibiGPT 的 OpenAPI / MCP / CLI 能力，**必须**同步 `skills/bibi/SKILL.md` 或对应 `references/*.md`。流程：

1. 改 `bibigpt-core` 的能力代码
2. 改这个 submodule 里的对应文档（commit + push 子模块）
3. 在父仓 bump submodule pointer（commit + push 父仓）

子模块没 push 时父仓 push 会被 husky pre-push 拦下（`check-submodule-pushed.sh`），别试 `--no-verify` 绕。

## 三个相关 reference 的边界

- `references/cli.md` — `bibi` CLI 命令列表 + flags
- `references/api.md` — REST/OpenAPI 端点 + curl 示例
- `references/installation.md` — 装 desktop / skill / 配 token / MCP
- `references/billing-aipay.md` — 402 协议 agent 侧处理（不写我们的 APPID）
- `references/supported-platforms.md` — 支持的 URL 类型

更细的内部实现细节、协议字段二进制 layout、错误码完整集等等，放到根仓 `notes/`，**不要**塞进 references。
