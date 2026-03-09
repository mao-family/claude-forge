# Insight: everything-claude-code Rules 适用性分析

**Date:** 2026-03-09

**Sources:**

- [Research: everything-claude-code](../research/everything-claude-code.md)
- <https://github.com/affaan-m/everything-claude-code/tree/main/rules>

---

## Summary

everything-claude-code 的 rules 结构采用 `common/` + 语言特定目录的分层模式，包含 9 个通用规则文件。与 claude-me 现有的 5 个规则文件对比后，发现 claude-me 在 workflow、shell、docs 方面已更完善，但在 coding-style、security 方面有补充价值。

## Key Findings

| # | Finding |
|---|---------|
| 1 | everything-claude-code rules 分为 common + 语言特定（typescript/python/golang/swift） |
| 2 | claude-me 已有完整的 workflow.md、shell.md、writing-docs.md、docs-sync.md、using-lint.md |
| 3 | everything-claude-code 的 coding-style.md 包含不可变性、文件大小限制、错误处理等通用原则 |
| 4 | everything-claude-code 的 security.md 包含安全检查清单、密钥管理、事件响应 |
| 5 | everything-claude-code 的 testing.md 内容已被 superpowers:test-driven-development 覆盖 |

## 详细对比

### 已覆盖（无需引入）

| 他们的 Rules | claude-me 等价物 | 状态 |
|-------------|-----------------|------|
| development-workflow.md | rules/workflow.md + superpowers skills | ✅ 我们更完整（6 阶段 vs 4 阶段） |
| git-workflow.md | 内置 Claude Code 行为 | ✅ 无需额外规则 |
| testing.md | superpowers:test-driven-development | ✅ 已通过 skill 覆盖 |
| hooks.md | hooks/hooks.json + memory-bank/architecture.md | ✅ 已有实现 |
| agents.md | superpowers 的 agent skills | ✅ 通过 skills 而非 rules 实现 |

### 有补充价值（建议引入）

| 他们的 Rules | 价值 | 建议 |
|-------------|------|------|
| coding-style.md | 不可变性原则、文件大小限制（200-400行）、函数长度（<50行）、嵌套深度（≤4层） | 🔶 创建 rules/coding-style.md |
| security.md | 安全检查清单、密钥管理、事件响应流程 | 🔶 创建 rules/security.md |

### 不适用

| 他们的 Rules | 原因 |
|-------------|------|
| patterns.md | Skeleton Projects 概念可以融入 brainstorming skill；Repository Pattern 太语言特定 |
| performance.md | 模型选择策略可以作为 knowledge，不需要作为强制 rules |
| 语言特定规则 | claude-me 主要是 Shell/Markdown，已有 shell.md 覆盖 |

## Implications for claude-me

1. **现有 rules 已经很完善** - workflow、shell、docs 三个核心领域都有高质量覆盖
2. **通用编码原则缺失** - 没有关于文件大小、函数长度、不可变性的通用指导
3. **安全意识缺失** - 没有安全检查清单和密钥管理规则
4. **不需要语言特定规则** - claude-me 不是多语言项目

## Recommendations

| Priority | Recommendation | Rationale |
|----------|----------------|-----------|
| 🔶 MEDIUM | 创建 `rules/coding-style.md` | 补充通用编码原则：不可变性、文件大小、函数长度、嵌套深度 |
| 🔶 MEDIUM | 创建 `rules/security.md` | 补充安全检查清单、密钥管理规则 |
| 🟢 LOW | 将 performance.md 内容加入 memory-bank | 模型选择策略作为参考知识，非强制规则 |
| ⬜ SKIP | 引入语言特定规则 | 不适用于 claude-me 的技术栈 |
| ⬜ SKIP | 引入 patterns.md | 可通过 brainstorming skill 处理 |

## 建议的 rules/coding-style.md 内容大纲

```text
# Coding Style Rules

## Immutability
- ALWAYS create new objects, NEVER mutate existing ones

## File Size
- Target: 200-400 lines per file
- Maximum: 800 lines (split if larger)

## Function Length
- Maximum: 50 lines per function
- Functions should do one thing

## Nesting Depth
- Maximum: 4 levels of nesting
- Extract to functions if deeper

## Error Handling
- Never silently ignore errors
- Log with context for debugging
- User-friendly messages for UI

## Input Validation
- Validate at system boundaries
- Never trust external data
```

## 建议的 rules/security.md 内容大纲

```text
# Security Rules

## Pre-commit Checklist
- [ ] No hardcoded credentials
- [ ] User inputs validated
- [ ] Parameterized queries (if DB)
- [ ] HTML output sanitized
- [ ] Error responses don't expose internals

## Secret Management
- NEVER hardcode secrets in source code
- ALWAYS use environment variables or secret manager
- Check required credentials at startup

## Incident Response
1. Stop work immediately
2. Assess scope of exposure
3. Rotate compromised secrets
4. Audit codebase for similar issues
```
