# bibigpt-skill

让 AI Agent 拥有"看视频、听音频"的能力。

[BibiGPT](https://bibigpt.co) 是国内 Top 1 的 AI 音视频助理，本仓库把 BibiGPT 的核心能力封装成 **Agent Native Skill**，可供 Claude Code、OpenClaw、Codex、Cursor、ChatGPT、扣子（Coze）等任意支持工具调用的 Agent / 智能体平台直接接入。

> English version: see [README.md](./README.md)

---

## 身份展示｜About

**BibiGPT** 由 [@JimmyLv](https://github.com/JimmyLv) 团队开发，自 2023 年起持续打磨，是国内最早一批专注「AI 音视频内容理解」的产品，目前服务超过 **百万级** 用户，覆盖 B 站、YouTube、播客、抖音、小红书、Twitter/X、本地音视频文件等几十种来源。

我们专注于把"长内容"变得"快、搜、用"：
- **看得快**：长视频几秒生成结构化总结、思维导图、分章节笔记
- **搜得到**：全文字幕检索、关键帧定位、画面内容搜索
- **用得好**：一键生成公众号图文、小红书、PPT、博客文章等知识产物

技术栈：自研字幕引擎 + 多模型路由（GPT/Claude/Gemini 等）+ 视觉理解 + Notion / Obsidian 等笔记工具深度联动。

---

## 功能说明｜What It Does

本 Skill 把 BibiGPT 的能力拆成 **8 个原子工作流**，Agent 会根据用户意图自动路由到合适的工作流：

| 工作流 | 能做什么 | 典型触发语 |
|---|---|---|
| **快速总结**（quick-summary） | 粘贴一个链接 → 生成结构化 AI 总结 | "总结这个视频"、"summarize this" |
| **深度分析**（deep-dive） | 分章节拆解 + 关键观点 + 追问 Q&A | "分章节总结"、"chapter breakdown" |
| **字幕提取**（transcript-extract） | 拉取带时间戳的完整字幕 / 转写文本 | "获取字幕"、"extract subtitles" |
| **图文改写**（article-rewrite） | 视频 → 公众号图文 / 小红书 / 博客 | "改写成文章"、"turn into article" |
| **批量处理**（batch-process） | 一次处理多个 URL | "批量总结"、"batch summarize" |
| **跨源研究**（research-compile） | 多个视频跨源综合、对比、汇编 | "综合分析"、"compare these videos" |
| **导出笔记**（export-notes） | 直接保存到 Notion / Obsidian / 本地文件 | "导出到 Notion"、"save notes" |
| **画面分析**（visual-analysis） | 解析视频画面内容、PPT、屏幕文字 | "画面分析"、"分析这一段画面" |

**支持的内容来源**：

- 在线视频：YouTube、Bilibili、抖音 / TikTok、小红书、Twitter/X、Vimeo …
- 播客 / 音频：Apple Podcasts、小宇宙、喜马拉雅、网易云音乐、SoundCloud、本地 mp3/m4a/wav
- 本地文件：mp4 / mov / mkv / mp3 / m4a / wav 等常见格式
- 直链：任何公网可访问的音视频 URL

---

## 使用方法｜How to Use

本 Skill 提供 **3 种接入方式**，可按平台和场景自由选择：

### 方式 A · Remote MCP Server（推荐，零安装）

任何支持 MCP 协议的客户端（Claude、Cursor、ChatGPT、Manus、LobeChat、扣子等）都可以直接接入：

```
https://bibigpt.co/api/mcp
```

支持 OAuth 2.1 一键登录，也可以用 Bearer Token 直连。可用工具：

- `summarize_video` — 总结视频/播客 URL
- `summarize_video_with_config` — 自定义 prompt / 模型 / 语言
- `summarize_by_chapter` — 分章节总结
- `get_subtitle` — 拉取字幕（含时间戳）
- `create_summary_task` / `get_task_status` — 异步处理长视频

### 方式 B · OpenAPI（HTTP 直连）

适合容器、CI、Serverless、自建 Agent 后端等无 CLI 环境。在 [bibigpt.co/user/integration](https://bibigpt.co/user/integration) 获取 API Key 后：

```bash
curl -X POST https://bibigpt.co/api/open/summarize \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"url":"https://www.youtube.com/watch?v=xxxxx"}'
```

完整接口说明见 `skills/bibi/references/api.md`。

### 方式 C · BibiGPT Desktop + CLI Skill（本地）

适合 Claude Code / OpenClaw / Codex 等本地 Agent。一行命令安装桌面版：

```bash
curl -fsSL https://bibigpt.co/install.sh | bash
```

然后安装 Skill：

```bash
npx skills add JimmyLv/bibigpt-skill
```

之后即可在对话中直接说：

```
> 总结这个视频：https://www.bilibili.com/video/BVxxxxxx
> Summarize this local file: /path/to/meeting-recording.mp4
> 把这期播客改写成小红书文案
```

Agent 会自动检测当前环境（CLI 还是 API），并路由到对应的工作流。

### 对话式调用示例

| 用户输入 | Skill 行为 |
|---|---|
| `总结一下 https://www.bilibili.com/video/BVxxx` | → 快速总结，输出结构化要点 |
| `把这个播客分章节整理：<URL>` | → 深度分析，按时间轴拆章节 |
| `批量总结这 5 个 YouTube 视频，整理成对比表` | → 批量处理 + 跨源研究 |
| `这期视频里第 12 分钟那张 PPT 上写的是什么？` | → 画面分析，定位关键帧 |
| `把这个视频改写成公众号图文，配 3 张配图建议` | → 图文改写 |

---

## 注意事项｜Limitations

**适用范围**

- 适合：公开可访问的在线音视频、本地音视频文件、公网 URL 直链
- 适合：需要稳定结构化产出（要点 / 章节 / 字幕 / 图文）的批量场景
- 适合：研究、学习、内容创作、会议纪要、播客笔记等知识工作流

**不适合 / 暂不支持**

- 加密内容：会员专享、付费墙后、需要登录态的私有视频
- 直播流：实时直播尚未支持，需等结束后处理回放
- 极长内容：>4 小时的超长视频建议使用异步任务接口
- 版权限制：请确保你对处理的内容拥有合法使用权，本工具不参与版权判定
- 实时性：模型生成内容可能存在偏差，关键信息请以原视频为准

**配额与限速**

- 免费用户有每日处理次数与时长上限，详见 [bibigpt.co/pricing](https://bibigpt.co/pricing)
- API / MCP 调用按账户配额计费，长视频建议走异步接口
- 高并发场景（CI / 批量任务）建议预先购买 Pro 套餐或按需充值

**隐私与安全**

- 本地文件经过 BibiGPT 的字幕引擎处理，处理结果默认仅本人可见
- 不会将用户内容用于模型训练
- 企业用户可申请独立部署，详询 [bibigpt.co](https://bibigpt.co)

---

## 仓库结构

```
skills/bibi/
├── SKILL.md                  # 意图路由器：根据用户输入分发到工作流
├── scripts/
│   └── bibi-check.sh         # 自动检测 CLI / API 模式
├── references/
│   ├── cli.md                # CLI 命令参考
│   ├── api.md                # OpenAPI 端点参考（10 个端点）
│   ├── installation.md       # 安装与认证
│   └── supported-platforms.md# 支持的平台与限制
└── workflows/
    ├── quick-summary.md      # 快速总结
    ├── deep-dive.md          # 深度分析
    ├── transcript-extract.md # 字幕提取
    ├── article-rewrite.md    # 图文改写
    ├── batch-process.md      # 批量处理
    ├── research-compile.md   # 跨源研究
    ├── export-notes.md       # 导出笔记
    └── visual-analysis.md    # 画面分析
```

---

## 链接

- 官网：https://bibigpt.co
- 文档：https://docs.bibigpt.co
- API Key：https://bibigpt.co/user/integration
- GitHub：https://github.com/JimmyLv/bibigpt-skill
- 反馈：https://github.com/JimmyLv/bibigpt-skill/issues

## License

MIT
