# Insight: Vibe-Coding Workflow

**Date:** February 27, 2026

**Sources:**

- [Research: EnzeD/vibe-coding](../references/vibe-coding.md)
- [Research: obra/superpowers](../references/superpowers.md)
- [Research: affaan-m/everything-claude-code](../references/everything-claude-code.md)
- [Research: everything-claude-code Rules Collection](../references/everything-claude-code.md)
- [Community Resources](../references/community-resources.md)
- [OpenAI Harness Engineering](../references/openai-harness-engineering.md)

---

## Core Principles

| # | Principle |
|---|-----------|
| 1 | **Human Plans, AI Executes** |
| 2 | **Design Before Code** |
| 3 | **Repository = Single Source of Truth** |
| 4 | **Test First, Always** |
| 5 | **Encode Taste into Tooling** |

---

## Workflow Architecture

```text
┌─────────────────────────────────────────────────────────────────┐
│                         WORKFLOW FLOW                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐                   │
│  │INITIALIZE│───▶│BRAINSTORM│───▶│   PLAN   │                   │
│  │          │    │          │    │          │                   │
│  │ Hook:    │    │ Agent:   │    │ Agent:   │                   │
│  │ Session  │    │ architect│    │ planner  │                   │
│  │ Start    │    │          │    │          │                   │
│  └──────────┘    └──────────┘    └──────────┘                   │
│                        │               │                         │
│                        ▼               ▼                         │
│                  <HARD-GATE>     2-5 min tasks                   │
│                                        │                         │
│                                        ▼                         │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐                   │
│  │  LEARN   │◀───│  COMMIT  │◀───│  REVIEW  │◀──┐               │
│  │          │    │          │    │          │   │               │
│  │ Hook:    │    │ Hook:    │    │ Agents:  │   │               │
│  │ Session  │    │ PreTool  │    │ code-    │   │               │
│  │ End      │    │ Use      │    │ reviewer │   │               │
│  └──────────┘    └──────────┘    └──────────┘   │               │
│                                        ▲        │               │
│                                        │        │               │
│                                  ┌──────────┐   │               │
│                                  │ EXECUTE  │───┘               │
│                                  │          │                   │
│                                  │ Subagent │                   │
│                                  │ + TDD    │                   │
│                                  └──────────┘                   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Component Adoption Recommendations

### Skills (from superpowers + everything-claude-code)

| Priority | Skill | Purpose |
|----------|-------|---------|
| 🔴 HIGH | `brainstorming` | Enforce design-first approach |
| 🔴 HIGH | `test-driven-development` | TDD workflow enforcement |
| 🔴 HIGH | `writing-plans` | Generate 2-5 minute granular tasks |
| 🟡 MED | `subagent-driven-development` | Independent subagent per task |
| 🟡 MED | `systematic-debugging` | Root cause > random fixes |
| 🟢 LOW | `using-git-worktrees` | Feature isolation |

### Rules (from everything-claude-code)

| Priority | Rule | Purpose |
|----------|------|---------|
| 🔴 HIGH | `agents.md` | Multi-agent orchestration |
| 🔴 HIGH | `coding-style.md` | Immutability, file organization |
| 🔴 HIGH | `testing.md` | 80% coverage, TDD enforcement |
| 🔴 HIGH | `security.md` | Pre-commit security checklist |
| 🟡 MED | `development-workflow.md` | Plan → TDD → Review → Commit |

### Hooks

| Stage | Hook | Purpose |
|-------|------|---------|
| SessionStart | Load memory-bank | Restore context |
| SessionEnd | Save progress | Persist state |
| PreToolUse | Block dangerous ops | Safety guard |
| PostToolUse | Auto-format | Code quality |

### Agents (from everything-claude-code)

| Agent | Purpose | Model |
|-------|---------|-------|
| `planner` | Plan implementation steps | Opus |
| `architect` | System design decisions | Opus |
| `tdd-guide` | TDD workflow guidance | Opus |
| `code-reviewer` | Code quality review | Opus |
| `security-reviewer` | Security vulnerability analysis | Opus |

---

## TDD Workflow (Core)

```text
┌─────────┐     ┌─────────┐     ┌─────────┐
│   RED   │────▶│  GREEN  │────▶│REFACTOR │
│ Write   │     │ Implement│     │ Improve  │
│ Test    │     │ Code     │     │ Code     │
│ (Fail)  │     │ (Pass)   │     │ (Pass)   │
└─────────┘     └─────────┘     └─────────┘
     │                               │
     └───────────── LOOP ────────────┘
```

**Hard Requirements:**

- Minimum 80% test coverage
- Write test before code; violation = delete and restart
- Each step: write test → run → implement → run → commit

---

## Two-Stage Review System

| Stage | Focus | Gate |
|-------|-------|------|
| **Stage 1: Spec Review** | Does it match requirements? | Must pass before Stage 2 |
| **Stage 2: Code Review** | Is it well-built? | Must pass before merge |

---

## Anti-Patterns to Avoid

| Thought | Reality |
|---------|---------|
| "This is too simple for design" | Simple things are exactly when you skip design |
| "Let me just write the code first" | TDD violation - delete and restart |
| "I'll add tests later" | You won't. Write them first. |
| "The context is fine" | Fresh context per task prevents pollution |
| "I know what to do" | Still read memory-bank for latest state |

---

## Key Insight from OpenAI

> **"Building software still demands discipline, but the discipline shows up more in the scaffolding rather than the code."**

This is exactly what claude-me is building — the scaffolding (skills, hooks, MCP configs) that enables agents to work effectively.
