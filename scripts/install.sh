#!/bin/bash

# Claude Me - Configuration Installer
# Syncs Claude Code configuration to ~/.claude and ~/.mcp.json

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
CLAUDE_DIR="$HOME/.claude"

echo "🔧 Claude Me - Installing configuration..."

# Create .claude directory if not exists
mkdir -p "$CLAUDE_DIR"

# Backup existing configs
if [ -f "$CLAUDE_DIR/settings.json" ]; then
    cp "$CLAUDE_DIR/settings.json" "$CLAUDE_DIR/settings.json.backup"
    echo "📦 Backed up existing settings.json"
fi

if [ -f "$HOME/.mcp.json" ]; then
    cp "$HOME/.mcp.json" "$HOME/.mcp.json.backup"
    echo "📦 Backed up existing .mcp.json"
fi

# Install configurations
cp "$ROOT_DIR/config/settings.json" "$CLAUDE_DIR/settings.json"
echo "✅ Installed settings.json"

cp "$ROOT_DIR/config/mcp.json" "$HOME/.mcp.json"
echo "✅ Installed .mcp.json"

# Copy hooks if exists
if [ -f "$ROOT_DIR/hooks/hooks.json" ]; then
    cp "$ROOT_DIR/hooks/hooks.json" "$CLAUDE_DIR/hooks.json"
    echo "✅ Installed hooks.json"
fi

echo ""
echo "🎉 Claude Me installation complete!"
echo "   Restart Claude Code to apply changes."
echo ""
echo "💡 To setup workspace repos, run:"
echo "   bun run setup"
