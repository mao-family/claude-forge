# Research: claude-mem

**Date:** 2026-03-04

**Source:** <https://github.com/thedotmack/claude-mem>

---

## Overview

Claude-mem is a Claude Code plugin that automatically captures everything Claude does during coding sessions, compresses it with AI, and injects relevant context back into future sessions. It solves the problem of losing context when sessions end.

## Key Findings

- **5 Lifecycle Hooks**: SessionStart, UserPromptSubmit, PostToolUse, Stop, SessionEnd
- **Worker Service**: HTTP API on port 37777 with web UI, managed by Bun
- **Storage**: SQLite with FTS5 for full-text search + Chroma vector database for semantic search
- **Data Model**: Stores sessions, observations, and summaries
- **Progressive Disclosure**: 3-layer retrieval workflow (search → timeline → fetch details)
- **Token Efficiency**: Claims ~10x token savings by filtering before fetching details
- **MCP Tools**: `search`, `timeline`, `get_observations` endpoints
- **Privacy**: `<private>` tags exclude sensitive content from capture
- **Desktop Integration**: Supports Claude Desktop via skill

## Architecture

```text
┌────────────────────────────────────────────────────────────────┐
│                        Claude Code                              │
├────────────────────────────────────────────────────────────────┤
│  Hooks: SessionStart → UserPromptSubmit → PostToolUse → Stop   │
│                              │                                  │
│                              ▼                                  │
│                     Worker Service (Bun)                        │
│                     localhost:37777                             │
│                              │                                  │
│              ┌───────────────┼───────────────┐                  │
│              ▼               ▼               ▼                  │
│         SQLite/FTS5      Chroma DB      Web Viewer              │
│         (sessions,       (vectors)      (real-time              │
│         observations,                    stream)                │
│         summaries)                                              │
└────────────────────────────────────────────────────────────────┘
```

## Strengths

- **Automatic capture** - No manual intervention required; hooks capture naturally
- **Smart retrieval** - Progressive disclosure prevents token bloat
- **Hybrid search** - Both semantic (vector) and keyword (FTS5) search
- **Privacy controls** - `<private>` tags for sensitive content
- **Web UI** - Visual memory stream for debugging/inspection
- **MCP integration** - Exposes tools for structured access
- **Cross-session persistence** - Context survives session boundaries

## Weaknesses

- **External dependencies** - Requires Bun, uv, Chroma DB, SQLite
- **Background service** - Worker must run continuously on port 37777
- **AGPL license** - Copyleft requirements may limit commercial use
- **Black box compression** - No details on how semantic summaries are generated
- **No offline mode** - Appears to require running services
- **Complexity** - Many moving parts (hooks, worker, DBs, MCP)

## Technical Details

| Component | Technology |
|-----------|------------|
| Runtime | Bun |
| Database | SQLite 3 + FTS5 |
| Vector Store | Chroma |
| API Port | 37777 |
| Python | uv package manager |
| Node | ≥18.0.0 required |

## Hook Implementation Details

### hooks.json 结构

```json
{
  "description": "Claude-mem memory system hooks",
  "hooks": {
    "Setup": [...],
    "SessionStart": [...],
    "UserPromptSubmit": [...],
    "PostToolUse": [...],
    "Stop": [...]
  }
}
```

### 各 Hook 职责

| Hook | Matcher | 功能 | 超时 |
|------|---------|------|------|
| Setup | `*` | 运行 `setup.sh` 初始化 | 300s |
| SessionStart | `startup\|clear\|compact` | 1. `smart-install.js` 检查依赖 2. 启动 worker 3. 注入 context | 60-300s |
| UserPromptSubmit | (无) | `session-init` 初始化会话 | 60s |
| PostToolUse | `*` | `observation` 记录工具调用 | 120s |
| Stop | (无) | 1. `summarize` 生成摘要 2. `session-complete` 结束会话 | 30-120s |

### 命令模式

所有命令使用统一模式：

```bash
# 1. 解析插件根目录（环境变量或默认路径）
_R="${CLAUDE_PLUGIN_ROOT}"
[ -z "$_R" ] && _R="$HOME/.claude/plugins/marketplaces/thedotmack/plugin"

# 2. 通过 bun-runner.js 执行脚本
node "$_R/scripts/bun-runner.js" "$_R/scripts/worker-service.cjs" hook claude-code <action>
```

### bun-runner.js 解决的问题

```text
问题：smart-install.js 安装 Bun 到 ~/.bun/bin/bun
     但 Bun 不在 PATH 中（需重启终端）
     后续 hooks 找不到 bun 命令

解决：bun-runner.js 在多个位置查找 Bun
     - PATH 中查找
     - ~/.bun/bin/bun (Unix)
     - ~/.bun/bin/bun.exe (Windows)
     - /usr/local/bin/bun
     - /opt/homebrew/bin/bun
```

### 关键脚本

| 脚本 | 功能 |
|------|------|
| `smart-install.js` | 检查/安装 Bun、uv，安装依赖 |
| `bun-runner.js` | 查找 Bun 可执行文件，解决 PATH 问题 |
| `worker-service.cjs` | Worker HTTP API，处理所有 hook 动作 |
| `context-generator.cjs` | 生成上下文摘要，注入到 SessionStart |

### 数据流

```text
PostToolUse hook
    ↓
worker-service.cjs hook observation
    ↓
解析工具调用输入/输出
    ↓
存入 SQLite (observations 表)
    ↓
向量化存入 Chroma

SessionStart hook
    ↓
worker-service.cjs hook context
    ↓
context-generator.cjs
    ↓
查询相关 observations + summaries
    ↓
输出到 stdout（Claude 读取）
```

## Takeaways for claude-me

1. **Hook-based capture is effective** - Using Claude Code hooks for observation is a proven pattern
2. **Progressive disclosure for memory** - 3-layer retrieval (index → timeline → details) saves tokens
3. **Hybrid search** - Combining FTS and vector search provides better recall
4. **MCP for structured access** - Exposing memory via MCP tools enables flexible querying
5. **Privacy tagging** - Simple `<private>` tag pattern is user-friendly
6. **Worker architecture** - Background service enables real-time capture and web UI
7. **bun-runner.js 模式** - 解决新安装后 PATH 问题的巧妙方案
8. **CLAUDE_PLUGIN_ROOT 回退** - 使用 `[ -z "$_R" ] && _R=...` 模式处理环境变量缺失
