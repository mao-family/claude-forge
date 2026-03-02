# Technology Stack

## Overview

claude-me uses shell scripting as its primary language with a comprehensive toolchain for quality assurance.

## Primary Language

### Shell/Bash

- **Purpose**: Core scripting language for hooks, skills, and installation scripts
- **Files**: `*.sh`, `*.bats`
- **Dialect**: Bash (configured in `.shellcheckrc` and `.editorconfig`)

## Testing

### Bats-core

- **Purpose**: Bash Automated Testing System
- **Files**: `tests/*.bats`
- **Command**: `bun run test`
- **Integration**: Runs automatically via pre-commit hooks

## Linting and Formatting

### ShellCheck

- **Purpose**: Static analysis for shell scripts
- **Config**: `.shellcheckrc`
- **Features**: 11 optional rules enabled, follows source commands
- **Command**: `bun run lint:shell`

### shfmt

- **Purpose**: Shell script formatter
- **Config**: `.editorconfig` (shell-specific settings)
- **Features**: 2-space indent, case indent, space redirects
- **Command**: `bun run lint:format`

### markdownlint

- **Purpose**: Markdown style checker and fixer
- **Config**: `.markdownlint.json`
- **Features**: ~46 rules enabled, auto-fix support
- **Command**: `bun run lint:markdown`

## Automation

### pre-commit

- **Purpose**: Git hook management
- **Config**: `.pre-commit-config.yaml`
- **Features**: Runs all linters and tests before commit
- **Command**: `bun run lint`

## Editor Configuration

### EditorConfig

- **Purpose**: Consistent editor settings across IDEs
- **Config**: `.editorconfig`
- **Features**: UTF-8, LF line endings, 2-space indent, trim trailing whitespace

## Package Management

### Bun

- **Purpose**: JavaScript runtime for npm scripts
- **Config**: `package.json`
- **Scripts**: install, lint, lint:shell, lint:markdown, lint:format, test

## Claude Code Integration

### Plugin System

- **Purpose**: Extend Claude Code functionality
- **Metadata**: `.claude-plugin/`
- **Config**: `settings.json`, `mcp.json`
- **Installation**: Symlinks to `~/.claude/`

## Configuration Files

| File | Purpose |
|------|---------|
| `.editorconfig` | Editor settings |
| `.markdownlint.json` | Markdown rules |
| `.pre-commit-config.yaml` | Pre-commit hooks |
| `.shellcheckrc` | ShellCheck rules |
| `package.json` | npm scripts |
| `settings.json` | Claude Code settings |
| `mcp.json` | MCP server config |
