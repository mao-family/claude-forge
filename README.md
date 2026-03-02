# Claude Me

Personal AI digital worker / AI clone powered by Claude Code.

See [CLAUDE.md](CLAUDE.md) for architecture, principles, and directory structure.

## Quick Start

### Prerequisites

- macOS with **zsh**
- **Homebrew**

```bash
# Install tools
brew install fnm bun gh

# Configure ~/.zshrc
echo 'eval "$(fnm env)"' >> ~/.zshrc
source ~/.zshrc

# Setup Node.js and Claude Code
fnm install --lts
fnm use --lts
npm install -g @anthropic-ai/claude-code
```

### Configure GitHub

```bash
# Login
gh auth login

# Add to ~/.zshrc
export GITHUB_TOKEN_PERSONAL=""  # https://github.com/settings/tokens
export GITHUB_TOKEN_WORK=$(gh auth token)
```

### Installation

```bash
git clone https://github.com/mao-family/claude-me.git ~/Repos/claude-me
cd ~/Repos/claude-me
bun run install
claude plugin marketplace update claude-me-marketplace
```

Restart Claude Code. Done! 🎉

### Updating

```bash
cd ~/Repos/claude-me
git pull
claude plugin marketplace update claude-me-marketplace
```

Restart Claude Code.

## Development

### Prerequisites

```bash
brew install bats-core   # Testing framework
```

### Testing

```bash
# Run all tests
bats tests/

# Run specific test file
bats tests/hooks.bats

# Run with verbose output
bats -t tests/
```

### Test Files

| File | Description |
|------|-------------|
| `tests/hooks.bats` | Hook tests (project context, feature context) |
| `tests/skills.bats` | Skill tests (requires claude CLI) |
