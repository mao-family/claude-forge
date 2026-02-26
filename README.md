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
- MCP server connections (Notion, etc.)

## Usage

1. Clone this repo: `git clone https://github.com/maoshuyu/claude-forge.git`
2. Run installer: `./install.sh`
3. Restart Claude Code

## Updating

Edit configurations in this repo, commit, and run `./install.sh` again.
