# Claude Forge

Personal Claude Code configuration repository.

## Quick Start

### Step 1: Prerequisites

**Install Homebrew** (macOS):

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

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

Now you can run `claude` and let AI help you with the rest! 🤖

---

### Step 2: Login to GitHub

```bash
# Personal account (mao-family org)
gh auth login  # Login with maoshuyu

# Work account (infinity-microsoft org)
gh auth login  # Login with shuyumao_microsoft

# Verify accounts
gh auth status
```

### Step 3: Configure Tokens

Add to `~/.zshrc`:

```bash
# GitHub MCP tokens
export GITHUB_TOKEN_PERSONAL=""  # Optional: create at https://github.com/settings/tokens
export GITHUB_TOKEN_MICROSOFT=$(gh auth token)  # Dynamically get OAuth token from gh CLI
```

> **Note**: Using `$(gh auth token)` is recommended for `infinity-microsoft` org access, as it returns an OAuth token (`gho_*`) that bypasses the organization's classic PAT restrictions.

Then `source ~/.zshrc`.

### Step 4: Install

```bash
git clone https://github.com/mao-family/claude-forge.git
cd claude-forge
bun run install
```

### Step 5: Setup Workspace

```bash
bun run setup
```

Interactively select and clone repos to `~/.claude/workspace/repos/`.

### Step 6: Restart Claude Code

Done! 🎉

---

## Structure

```
claude-forge/
├── .claude-plugin/plugin.json   # Plugin metadata
├── config/
│   ├── settings.json            # Claude Code settings
│   ├── mcp.json                 # MCP server configuration
│   └── workspace.json           # Workspace configuration
├── scripts/
│   ├── install.sh               # Install configuration
│   └── setup-workspace.sh       # Interactive workspace setup
├── hooks/hooks.json             # Hook configuration
└── package.json                 # Bun scripts
```

## Configuration

### settings.json
- Environment variables for Claude Code
- Permission settings
- Plugin marketplace configuration

### mcp.json
- MCP server connections (Notion, GitHub, etc.)

### Workspace structure
```
~/.claude/workspace/
└── repos/                    # Git repositories
    ├── infinity-microsoft/
    │   ├── picasso/
    │   └── studio/
    └── mao-family/
        └── claude-forge/
```

## Updating

Edit configurations in this repo, commit, and run `bun run install` again.

## TODO

### Microsoft Teams MCP (office-365-mcp-server)

- [ ] Configure Microsoft Teams MCP

**Step 1: Register Azure App**
1. Go to https://portal.azure.com/#blade/Microsoft_AAD_RegisteredApps/ApplicationsListBlade
2. Click "New registration"
3. Fill in:
   - Name: `Claude MCP Office365`
   - Supported account types: `Accounts in this organizational directory only`
   - Redirect URI: Select `Web`, enter `http://localhost:3000/auth/callback`
4. Click "Register"
5. Note: For Microsoft internal accounts, you need a Service Tree ID from https://servicetree.msftcloudes.com

**Step 2: Configure API Permissions**
1. Go to "API permissions" → "Add a permission" → "Microsoft Graph" → "Delegated permissions"
2. Add these permissions:
   - `Mail.Read`, `Mail.Send` (Email)
   - `Calendars.ReadWrite` (Calendar)
   - `Chat.Read`, `ChannelMessage.Read.All` (Teams)
   - `Files.ReadWrite` (OneDrive)
   - `User.Read` (User info)
3. Click "Grant admin consent"

**Step 3: Get Credentials**
1. Copy `Application (client) ID` from Overview page
2. Go to "Certificates & secrets" → "New client secret"
3. Copy the generated secret value

**Step 4: Add Environment Variables to `~/.zshrc`**
```bash
# Office 365 MCP
export OFFICE_CLIENT_ID="your-client-id"
export OFFICE_CLIENT_SECRET="your-client-secret"
export OFFICE_TENANT_ID="your-tenant-id"
export OFFICE_REDIRECT_URI="http://localhost:3000/auth/callback"
```

**Step 5: Add to `config/mcp.json`**
```json
"office365": {
  "command": "node",
  "args": ["/path/to/office-365-mcp-server/index.js"],
  "env": {
    "OFFICE_CLIENT_ID": "${OFFICE_CLIENT_ID}",
    "OFFICE_CLIENT_SECRET": "${OFFICE_CLIENT_SECRET}",
    "OFFICE_TENANT_ID": "${OFFICE_TENANT_ID}",
    "OFFICE_REDIRECT_URI": "${OFFICE_REDIRECT_URI}"
  },
  "description": "Microsoft 365 (Teams, Outlook, Calendar)"
}
```

**Step 6: Install and Authenticate**
```bash
git clone https://github.com/hvkshetry/office-365-mcp-server.git
cd office-365-mcp-server
npm install
npm run auth-server  # Opens browser for OAuth login
```

Ref: https://github.com/hvkshetry/office-365-mcp-server

---

### Slack MCP (slack-mcp-server)

- [ ] Configure Slack MCP

**Step 1: Create Slack App**
1. Go to https://api.slack.com/apps
2. Click "Create New App" → "From scratch"
3. Enter App Name (e.g., `Claude MCP`) and select your Workspace

**Step 2: Configure OAuth Permissions**
1. Go to "OAuth & Permissions"
2. Add these User Token Scopes:
   - `channels:history`, `channels:read` (Public channels)
   - `groups:history`, `groups:read` (Private channels)
   - `im:history`, `im:read` (Direct messages)
   - `mpim:history`, `mpim:read` (Group DMs)
   - `users:read` (User info)
   - `search:read` (Search)
   - `team:read` (Team info)

**Step 3: Install App and Get Token**
1. Click "Install to Workspace"
2. Authorize the app
3. Copy the `User OAuth Token` (starts with `xoxp-...`)

**Step 4: Add Environment Variables to `~/.zshrc`**
```bash
# Slack MCP
export SLACK_MCP_XOXP_TOKEN="xoxp-your-token-here"
```

**Step 5: Add to `config/mcp.json`**
```json
"slack": {
  "command": "npx",
  "args": ["-y", "slack-mcp-server@latest", "--transport", "stdio"],
  "env": {
    "SLACK_MCP_XOXP_TOKEN": "${SLACK_MCP_XOXP_TOKEN}"
  },
  "description": "Slack workspace"
}
```

**Step 6: Apply and Restart**
```bash
source ~/.zshrc
./install.sh
# Restart Claude Code
```

Ref: https://github.com/korotovsky/slack-mcp-server

---

## Known Issues

### GitHub MCP cannot access `infinity-microsoft` organization

**Problem**: The `github-microsoft` MCP server cannot access `infinity-microsoft` repos.

**Error**:
```
Permission Denied: `infinity-microsoft` forbids access via a personal access token (classic).
Please use a GitHub App, OAuth App, or a personal access token with fine-grained permissions.
```

**Cause**: The `infinity-microsoft` organization has disabled classic PAT (`ghp_*`) access for security reasons.

**Solution**: Use `gh auth token` to dynamically get an OAuth token:

```bash
# In ~/.zshrc
export GITHUB_TOKEN_MICROSOFT=$(gh auth token)
```

This returns an OAuth token (`gho_*`) that is allowed by the organization. After updating, run:
```bash
source ~/.zshrc
# Restart Claude Code
```

**Alternative - Use `gh` CLI directly** for `infinity-microsoft` repos:
```bash
# Switch to Microsoft account
gh auth switch --user shuyumao_microsoft

# Then use --repo flag for any operation
gh pr list --repo infinity-microsoft/picasso
gh pr view 123 --repo infinity-microsoft/picasso
gh pr merge 123 --repo infinity-microsoft/picasso --squash
gh repo list infinity-microsoft
```

### GitHub Token Types Reference

| Prefix | Type | Usage | `infinity-microsoft` Access |
|--------|------|-------|----------------------------|
| `ghp_*` | Classic PAT | Manual creation | ❌ Blocked by org policy |
| `github_pat_*` | Fine-grained PAT | Manual creation | ✅ If configured correctly |
| `gho_*` | OAuth App Token | `gh auth token` | ✅ Recommended |
| `ghu_*` | User-to-Server Token | GitHub App (e.g., Copilot) | ⚠️ Limited scopes |
