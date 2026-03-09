# Swift Hooks

> This file extends [common/hooks.md](../common/hooks.md) with Swift specific content.

Applies to: `*.swift`, `Package.swift`

## PostToolUse Hooks

Configure in `~/.claude/settings.json`:

### SwiftFormat

Auto-format Swift files after edit:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "swiftformat $CLAUDE_FILE_PATH",
            "match_files": ["**/*.swift"]
          }
        ]
      }
    ]
  }
}
```

### SwiftLint

Run linter after edit:

```json
{
  "type": "command",
  "command": "swiftlint lint --path $CLAUDE_FILE_PATH",
  "match_files": ["**/*.swift"]
}
```

### Type Checking

Run swift build for type checking:

```json
{
  "type": "command",
  "command": "swift build",
  "match_files": ["**/Package.swift", "**/*.swift"]
}
```

## Print Statement Detection

**Avoid `print()` in production code. Use `os.Logger` instead.**

```json
{
  "type": "command",
  "command": "grep -n 'print(' $CLAUDE_FILE_PATH && echo 'WARNING: print() detected - use os.Logger'",
  "match_files": ["**/*.swift"]
}
```

## Structured Logging

**Use os.Logger for production:**

```swift
import os

extension Logger {
    static let app = Logger(subsystem: "com.myapp", category: "general")
    static let network = Logger(subsystem: "com.myapp", category: "network")
}

// Usage
Logger.app.info("User logged in: \(userId)")
Logger.network.error("Request failed: \(error)")
```

## Combined Hook

Run all Swift tools in sequence:

```json
{
  "type": "command",
  "command": "swiftformat $CLAUDE_FILE_PATH && swiftlint lint --path $CLAUDE_FILE_PATH",
  "match_files": ["**/*.swift"]
}
```

## Related Documentation

| Document | Content |
|----------|---------|
| [common/hooks.md](../common/hooks.md) | Universal hook principles |
