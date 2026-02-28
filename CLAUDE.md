# claude-me

Personal AI digital worker / AI clone powered by Claude Code.

## Core Principles

1. **Human Plans, AI Executes** - You plan, I execute
2. **Design Before Code** - Think before you code
3. **Repository = Single Source of Truth** - Everything lives in the repo
4. **Test First, Always** - TDD by default
5. **Encode Taste into Tooling** - Codify preferences into skills, agents, hooks

## Knowledge Locations

### claude-me
- `CLAUDE.md` - Global instructions (auto-loaded by Claude Code)
- `memory-bank/` - claude-me project knowledge

### Child Projects
When working in `workspace/repos/{project}/`:
→ Read `workspace/memory-bank/{project}/CLAUDE.md`

When on `feature/{name}` branch:
→ Read `workspace/memory-bank/{project}/features/{name}/*.md`

## Directory Structure

### Repository
```
https://github.com/mao-family/claude-me
~/Repos/claude-me/
├── .claude-plugin/          # Plugin metadata
├── skills/                  # Workflow guides
├── agents/                  # Specialized sub-agents
├── hooks/                   # Automation hooks
├── rules/                   # Coding standards
├── references/              # External knowledge docs
├── scripts/                 # Installation and utility scripts
├── memory-bank/             # claude-me project knowledge
├── workspace/
│   ├── repos/{project}/     # Child project repositories
│   └── memory-bank/{project}/ # Child project knowledge
├── CLAUDE.md                # Global instructions
├── mcp.json                 # MCP server config
└── settings.json            # Claude Code settings
```

### Runtime
```
~/.claude/
├── CLAUDE.md → claude-me
├── settings.json → claude-me
├── rules/ → claude-me
├── workspace/ → claude-me
├── memory-bank/ → claude-me
├── settings.local.json      # Local secrets (not in repo)
└── plugins/                 # Plugin: claude-me@claude-me-marketplace

~/.mcp.json → claude-me/mcp.json
```

## Commands

```bash
# Install (create symlinks + setup plugin)
./scripts/install.sh

# Update plugin cache
claude plugin marketplace update claude-me-marketplace
```

## Development

See README.md for setup instructions.
