# TypeScript Hooks

> This file extends [common/hooks.md](../common/hooks.md) with TypeScript/JavaScript specific content.

Applies to: `*.ts`, `*.tsx`, `*.js`, `*.jsx`

## PostToolUse Hooks

Configure in `~/.claude/settings.json`:

### Prettier Formatting

Auto-format JS/TS files after edit:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "npx prettier --write $CLAUDE_FILE_PATH",
            "match_files": ["**/*.ts", "**/*.tsx", "**/*.js", "**/*.jsx"]
          }
        ]
      }
    ]
  }
}
```

### TypeScript Type Checking

Run `tsc` after TypeScript file edits:

```json
{
  "type": "command",
  "command": "npx tsc --noEmit",
  "match_files": ["**/*.ts", "**/*.tsx"]
}
```

### Console.log Detection

Warn when console.log appears:

```json
{
  "type": "command",
  "command": "grep -n 'console.log' $CLAUDE_FILE_PATH && echo 'WARNING: console.log detected'",
  "match_files": ["**/*.ts", "**/*.tsx", "**/*.js", "**/*.jsx"]
}
```

## Stop Hooks

Before session end, audit for console.log:

```json
{
  "hooks": {
    "Stop": [
      {
        "type": "command",
        "command": "git diff --name-only | xargs grep -l 'console.log' || true"
      }
    ]
  }
}
```

## ESLint Integration

Run ESLint after edits:

```json
{
  "type": "command",
  "command": "npx eslint --fix $CLAUDE_FILE_PATH",
  "match_files": ["**/*.ts", "**/*.tsx", "**/*.js", "**/*.jsx"]
}
```

## Related Documentation

| Document | Content |
|----------|---------|
| [common/hooks.md](../common/hooks.md) | Universal hook principles |
