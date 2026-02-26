# Claude Forge

Personal Claude Code configuration repository.

## Quick Install

```bash
./install.sh
```

## Structure

```
claude-forge/
├── .claude-plugin/plugin.json   # Plugin metadata
├── config/
│   ├── settings.json            # Claude Code settings
│   └── mcp.json                 # MCP server configuration
├── rules/common/                # Common rules (TODO)
├── hooks/hooks.json             # Hook configuration
└── install.sh                   # Installation script
```

## Configuration

### settings.json
- Environment variables for Claude Code
- Permission settings
- Plugin marketplace configuration

### mcp.json
- MCP server connections (Notion, GitHub, etc.)

### GitHub MCP Setup

Add GitHub tokens to your `~/.zshrc`:

```bash
# GitHub MCP tokens
export GITHUB_TOKEN_PERSONAL="ghp_your_personal_token"
export GITHUB_TOKEN_MICROSOFT="ghp_your_microsoft_token"
```

Then run `source ~/.zshrc` to apply.

## Usage

1. Clone this repo: `git clone https://github.com/maoshuyu/claude-forge.git`
2. Run installer: `./install.sh`
3. Restart Claude Code

## Updating

Edit configurations in this repo, commit, and run `./install.sh` again.
