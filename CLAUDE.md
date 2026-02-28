# claude-me

Personal AI digital worker / AI clone powered by Claude Code.

**Repository:** https://github.com/mao-family/claude-me
**Runtime:** Symlinks (`~/.claude/`, `~/.mcp.json`) + Plugin (`claude-me@claude-me-marketplace`)

## Core Principles

1. **Human Plans, AI Executes** - You plan, I execute
2. **Design Before Code** - Think before you code
3. **Repository = Single Source of Truth** - Everything lives in the repo
4. **Test First, Always** - TDD by default
5. **Encode Taste into Tooling** - Codify preferences into skills, agents, hooks

## Knowledge Locations

### Global (auto-loaded by Claude Code)
- This file (`~/.claude/CLAUDE.md`) - loaded automatically on every session

### Project Knowledge
When in `workspace/repos/{project}/`:
→ Read `workspace/memory-bank/{project}/CLAUDE.md`

### Feature Knowledge
When on `feature/{name}` branch:
→ Read `workspace/memory-bank/{project}/features/{name}/*.md`

## Directory Structure

- `.claude-plugin/` - Plugin metadata
- `skills/` - Workflow guides
- `agents/` - Specialized sub-agents
- `hooks/` - Automation hooks
- `rules/` - Coding standards
- `references/` - External knowledge docs
- `scripts/` - Installation and utility scripts
- `workspace/` - Project workspace
  - `memory-bank/{project}/` - Project knowledge
  - `repos/{project}/` - Git repositories
- `CLAUDE.md` - Global instructions (symlinked to ~/.claude/)
- `mcp.json` - MCP server config (symlinked to ~/.mcp.json)
- `settings.json` - Claude Code settings (symlinked to ~/.claude/)

## Commands

```bash
# Install (create symlinks + setup plugin)
./scripts/install.sh

# Update plugin cache
claude plugin marketplace update claude-me-marketplace
```

## Development

See README.md for setup instructions.
