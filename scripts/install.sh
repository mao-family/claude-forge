#!/bin/bash

# Claude Me - Installation Script
# Clones claude-me to ~/.claude/ (or updates if exists)

set -e

CLAUDE_DIR="$HOME/.claude"
REPO_URL="https://github.com/mao-family/claude-me.git"

echo "🔧 Claude Me - Installing..."

# Check if ~/.claude exists
if [ -d "$CLAUDE_DIR" ]; then
    # Check if it's already a git repo (claude-me)
    if [ -d "$CLAUDE_DIR/.git" ]; then
        echo "📦 Updating existing claude-me installation..."
        cd "$CLAUDE_DIR"
        git pull
        echo "✅ Updated claude-me"
    else
        # Existing Claude Code directory, need to merge
        echo "📦 Found existing ~/.claude directory"
        echo "   Backing up and merging with claude-me..."

        # Create temp directory for clone
        TEMP_DIR=$(mktemp -d)
        git clone "$REPO_URL" "$TEMP_DIR"

        # Move .git to ~/.claude
        mv "$TEMP_DIR/.git" "$CLAUDE_DIR/.git"

        # Copy new files (don't overwrite existing)
        cp -n "$TEMP_DIR/CLAUDE.md" "$CLAUDE_DIR/" 2>/dev/null || true
        cp -n "$TEMP_DIR/settings.json" "$CLAUDE_DIR/" 2>/dev/null || true
        cp -n "$TEMP_DIR/mcp.json" "$CLAUDE_DIR/" 2>/dev/null || true
        cp -rn "$TEMP_DIR/skills" "$CLAUDE_DIR/" 2>/dev/null || true
        cp -rn "$TEMP_DIR/agents" "$CLAUDE_DIR/" 2>/dev/null || true
        cp -n "$TEMP_DIR/hooks.json" "$CLAUDE_DIR/" 2>/dev/null || true
        cp -rn "$TEMP_DIR/rules" "$CLAUDE_DIR/" 2>/dev/null || true
        cp -rn "$TEMP_DIR/references" "$CLAUDE_DIR/" 2>/dev/null || true
        cp -rn "$TEMP_DIR/workspace" "$CLAUDE_DIR/" 2>/dev/null || true
        cp -n "$TEMP_DIR/.gitignore" "$CLAUDE_DIR/" 2>/dev/null || true
        cp -n "$TEMP_DIR/README.md" "$CLAUDE_DIR/" 2>/dev/null || true
        cp -n "$TEMP_DIR/package.json" "$CLAUDE_DIR/" 2>/dev/null || true
        cp -rn "$TEMP_DIR/scripts" "$CLAUDE_DIR/" 2>/dev/null || true

        # Cleanup
        rm -rf "$TEMP_DIR"

        echo "✅ Merged claude-me with existing ~/.claude"
    fi
else
    # Fresh install
    echo "📦 Fresh installation..."
    git clone "$REPO_URL" "$CLAUDE_DIR"
    echo "✅ Cloned claude-me to ~/.claude"
fi

# Create settings.local.json if not exists
if [ ! -f "$CLAUDE_DIR/settings.local.json" ]; then
    echo '{}' > "$CLAUDE_DIR/settings.local.json"
    echo "✅ Created settings.local.json (add your secrets here)"
fi

# Copy mcp.json to ~/.mcp.json (Claude Code reads from here)
cp "$CLAUDE_DIR/mcp.json" "$HOME/.mcp.json"
echo "✅ Installed .mcp.json"

echo ""
echo "🎉 Claude Me installation complete!"
echo ""
echo "📁 Installed to: ~/.claude/"
echo "📝 Edit ~/.claude/settings.local.json to add secrets"
echo ""
echo "🔄 Restart Claude Code to apply changes."
