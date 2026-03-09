# Python Hooks

> This file extends [common/hooks.md](../common/hooks.md) with Python specific content.

Applies to: `*.py`, `*.pyi`

## PostToolUse Hooks

Configure in `~/.claude/settings.json`:

### Black Formatting

Auto-format Python files after edit:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "black $CLAUDE_FILE_PATH",
            "match_files": ["**/*.py"]
          }
        ]
      }
    ]
  }
}
```

### isort Import Sorting

Sort imports after edit:

```json
{
  "type": "command",
  "command": "isort $CLAUDE_FILE_PATH",
  "match_files": ["**/*.py"]
}
```

### Ruff Linting

Run linter after edit:

```json
{
  "type": "command",
  "command": "ruff check --fix $CLAUDE_FILE_PATH",
  "match_files": ["**/*.py"]
}
```

### Type Checking

Run mypy after edit:

```json
{
  "type": "command",
  "command": "mypy $CLAUDE_FILE_PATH",
  "match_files": ["**/*.py"]
}
```

## Print Statement Detection

Warn when print() appears:

```json
{
  "type": "command",
  "command": "grep -n 'print(' $CLAUDE_FILE_PATH && echo 'WARNING: print() detected'",
  "match_files": ["**/*.py"]
}
```

## Combined Hook

Run all Python tools in sequence:

```json
{
  "type": "command",
  "command": "black $CLAUDE_FILE_PATH && isort $CLAUDE_FILE_PATH && ruff check --fix $CLAUDE_FILE_PATH",
  "match_files": ["**/*.py"]
}
```

## Related Documentation

| Document | Content |
|----------|---------|
| [common/hooks.md](../common/hooks.md) | Universal hook principles |
