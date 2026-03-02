---
name: managing-workspace
description: Use when user wants to add repos to workspace, clone projects, remove repos from workspace, update workspace repos, or list workspace status. Triggers on "添加仓库", "clone X 到 workspace", "删除 workspace 中的", "更新仓库", "列出 workspace".
---

# Managing Workspace

Manage child project repositories in `workspace/repos/`.

## Operations

| Operation | Triggers | Action |
|-----------|----------|--------|
| **Add** | 添加、clone、add repo | Search → clone → create memory-bank |
| **Remove** | 删除、移除、remove | Delete repo → archive memory-bank |
| **Update** | 更新、pull、sync | git pull |
| **List** | 列出、查看、list | Show all repos status |

## Add Repo

### Flow

```dot
digraph add_repo {
  "Get repo name or owner/repo" -> "Has owner?";
  "Has owner?" -> "Determine gh account" [label="yes"];
  "Has owner?" -> "Search across all accounts" [label="no"];
  "Search across all accounts" -> "Found?" ;
  "Found?" -> "Present results to user" [label="multiple"];
  "Found?" -> "Determine gh account" [label="single"];
  "Found?" -> "Report not found" [label="none"];
  "Present results to user" -> "User selects" -> "Determine gh account";
  "Determine gh account" -> "Switch to correct account";
  "Switch to correct account" -> "Clone to workspace/repos/";
  "Clone to workspace/repos/" -> "Create memory-bank dir";
  "Create memory-bank dir" -> "Prompt about writing-claude-md";
}
```

### Search Across All Accounts

When user provides only repo name (no owner), search across all configured accounts:

```bash
# Get all accounts
accounts=$(gh auth status 2>&1 | grep "Logged in to github.com account" | sed 's/.*account //' | sed 's/ .*//')

# Search each account
for account in ${accounts}; do
  gh auth switch --user "${account}" 2>/dev/null
  echo "=== Searching as ${account} ==="
  gh search repos "<repo_name>" --limit 5 --json fullName,description
done
```

If multiple results found, present them to the user and ask which one to clone.

### GitHub Accounts

Available `gh` CLI accounts (check with `gh auth status`):

| Account | Organizations | Usage |
|---------|---------------|-------|
| `maoshuyu` | mao-family | Personal projects (default) |
| `shuyumao_microsoft` | infinity-microsoft | Microsoft work |
| `maoku-family` | - | Family projects |

### Determine Account

Based on repo owner:

| Owner Pattern | Account |
|---------------|---------|
| `infinity-microsoft/*` | `shuyumao_microsoft` |
| `mao-family/*` | `maoshuyu` |
| `maoku-family/*` | `maoku-family` |
| Other | Try `maoshuyu` first |

### Clone

```bash
# Switch to correct account (if needed)
gh auth switch --user <account>

# Clone
cd workspace/repos
gh repo clone <owner>/<repo>

# Create memory-bank
mkdir -p ../memory-bank/<repo>/
```

> **Note:** 不需要切换回默认账户。`gh` 的 git-credential helper 会根据 repo URL 自动选择正确的账户进行认证。

### Completion Message

```text
✅ 已添加 <repo> 到 workspace
📁 已创建 workspace/memory-bank/<repo>/
💡 可使用 writing-claude-md skill 生成项目 CLAUDE.md
```

## Remove Repo

### Flow

1. Verify `workspace/repos/{project}/` exists
2. Delete repo directory
3. Archive memory-bank (NOT delete):
   - Move `workspace/memory-bank/{project}/` to `workspace/memory-bank/archived/{project}/`

### Commands

```bash
rm -rf workspace/repos/<project>
mkdir -p workspace/memory-bank/archived
mv workspace/memory-bank/<project> workspace/memory-bank/archived/
```

### Completion Message

```text
✅ 已删除 <project>
📦 已归档 workspace/memory-bank/archived/<project>/
```

## Update Repo

### Single Repo

```bash
cd workspace/repos/<project>
git pull
```

### All Repos

```bash
for repo in workspace/repos/*/; do
  echo "Updating $(basename $repo)..."
  (cd "$repo" && git pull)
done
```

## List Repos

### Output Format

```text
workspace/repos/
├── studio
│   ├── 分支: main
│   ├── 状态: clean
│   └── memory-bank: ✓
├── another-project
│   ├── 分支: feature/new-feature
│   ├── 状态: 3 uncommitted changes
│   └── memory-bank: ✗
```

Show for each repo:

- Name
- Current branch
- Uncommitted changes count
- Whether memory-bank exists

## Switch Workspace

> **TODO:** Needs solution for context path resolution.
>
> Problem: After switching, may read wrong CLAUDE.md path.
> Need "current workspace" concept to ensure correct memory-bank paths.

## Directory Structure

```text
workspace/
├── repos/
│   ├── studio/
│   └── another-project/
└── memory-bank/
    ├── studio/
    │   └── CLAUDE.md
    ├── another-project/
    └── archived/
        └── deleted-project/
```
