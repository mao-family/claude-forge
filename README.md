# Claude Me

Personal AI digital worker / AI clone powered by Claude Code.

## Architecture

```
~/Repos/claude-me/                 # Repository (single source of truth)
├── .claude-plugin/plugin.json     # Plugin metadata
├── hooks/hooks.json               # Plugin: hooks
├── skills/                        # Plugin: skills
├── agents/                        # Plugin: agents
├── CLAUDE.md                      # ──symlink──→ ~/.claude/
├── mcp.json                       # ──symlink──→ ~/.claude/
├── settings.json                  # ──symlink──→ ~/.claude/
├── rules/                         # ──symlink──→ ~/.claude/
├── workspace/                     # ──symlink──→ ~/.claude/
├── references/
├── scripts/
└── README.md

~/.claude/                         # Claude Code runtime directory
├── CLAUDE.md → claude-me          # Symlink
├── mcp.json → claude-me           # Symlink
├── settings.json → claude-me      # Symlink
├── rules/ → claude-me             # Symlink
├── workspace/ → claude-me         # Symlink
├── settings.local.json            # Local secrets (not in repo)
├── plugins/                       # Claude Code native
├── history.jsonl                  # Claude Code native
└── ... (cache, debug, etc.)
```

**Key Design:**
- **Symlinks (5)**: `CLAUDE.md`, `mcp.json`, `settings.json`, `rules/`, `workspace/`
- **Plugin (3)**: `hooks/`, `skills/`, `agents/`
- **Native**: `settings.local.json`, `history.jsonl`, etc.

## Quick Start

### Prerequisites

**Requirements:**
- macOS with **zsh** (default shell on macOS 10.15+)
- **Homebrew** - package manager

**Install tools:**

```bash
brew install fnm bun gh
```

**Configure `~/.zshrc`:**

```bash
# fnm (Node.js version manager)
eval "$(fnm env)"
```

Then `source ~/.zshrc`.

**Setup Node.js and Claude Code:**

```bash
fnm install --lts
fnm use --lts
npm install -g @anthropic-ai/claude-code
```

### Installation

```bash
# Clone repository
git clone https://github.com/mao-family/claude-me.git ~/Repos/claude-me

# Run install script
cd ~/Repos/claude-me
./scripts/install.sh
```

The install script will:
1. Create symlinks from `~/.claude/` to the repository
2. Install claude-me as a local plugin (for hooks, skills, agents)
3. Create `settings.local.json` for your secrets

### Login to GitHub

```bash
# Personal account
gh auth login  # Login with your account

# Work account (if needed)
gh auth login  # Login with work account

# Verify
gh auth status
```

### Configure Tokens

Add to `~/.zshrc`:

```bash
# GitHub MCP tokens
export GITHUB_TOKEN_PERSONAL=""  # Create at https://github.com/settings/tokens
export GITHUB_TOKEN_WORK=$(gh auth token)  # OAuth token from gh CLI
```

Then `source ~/.zshrc`.

### Restart Claude Code

Done! 🎉

## Structure

### Plugin Components (loaded via plugin system)

| Component | Path | Description |
|-----------|------|-------------|
| Hooks | `hooks/hooks.json` | SessionStart, PreToolUse, etc. |
| Skills | `skills/{name}/SKILL.md` | Workflow definitions |
| Agents | `agents/{name}.md` | Specialized sub-agents |

### Symlinked Components

| Component | Path | Description |
|-----------|------|-------------|
| CLAUDE.md | Root | Global instructions |
| mcp.json | Root | MCP server configuration |
| settings.json | Root | Claude Code settings |
| rules/ | Directory | Coding standards |
| workspace/ | Directory | Projects and memory-bank |

### Workspace Structure

```
workspace/
├── memory-bank/              # Project knowledge
│   └── {project}/
│       ├── CLAUDE.md         # Project entry
│       ├── context.md
│       ├── architecture.md
│       └── features/
│           └── {feature}/
│               ├── design.md
│               ├── plan.md
│               └── progress.md
└── repos/                    # Git repositories
    └── {org}/
        └── {project}/
```

## Enabled Plugins

| Plugin | Marketplace | Description |
|--------|-------------|-------------|
| `superpowers` | `superpowers-marketplace` | TDD, debugging, collaboration patterns |
| `example-skills` | `anthropic-agent-skills` | skill-creator, mcp-builder, frontend-design |
| `claude-me` | local | Your custom hooks, skills, agents |

## Updating

```bash
cd ~/Repos/claude-me
git pull
# Restart Claude Code
```

## Core Principles

1. **Human Plans, AI Executes** - 人类规划，AI执行
2. **Design Before Code** - 设计先于编码
3. **Repository = Single Source of Truth** - 仓库是唯一真相来源
4. **Test First, Always** - 始终测试优先
5. **Encode Taste into Tooling** - 将品味编码到工具中

## TODO

### Microsoft Teams MCP

See [office-365-mcp-server](https://github.com/hvkshetry/office-365-mcp-server) for setup instructions.

### Slack MCP

See [slack-mcp-server](https://github.com/korotovsky/slack-mcp-server) for setup instructions.

## Known Issues

### GitHub MCP cannot access organization repos

**Problem**: Some organizations block classic PAT (`ghp_*`) access.

**Solution**: Use `gh auth token` to get an OAuth token:

```bash
# In ~/.zshrc
export GITHUB_TOKEN_WORK=$(gh auth token)
```

This returns an OAuth token (`gho_*`) that is allowed by most organizations.

### GitHub Token Types Reference

| Prefix | Type | Usage | Org Access |
|--------|------|-------|------------|
| `ghp_*` | Classic PAT | Manual creation | ❌ Often blocked |
| `github_pat_*` | Fine-grained PAT | Manual creation | ✅ If configured |
| `gho_*` | OAuth App Token | `gh auth token` | ✅ Recommended |
