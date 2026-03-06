# Workflow Rules

## Development Flow

Follow superpowers workflow for all feature development:

```text
BRAINSTORM → PLAN → EXECUTE → FINISH
```

## Before Execution

**When user approves a plan, BEFORE starting execution:**

1. Run `/plan` to initialize planning-with-files
2. This creates: `task_plan.md`, `findings.md`, `progress.md`
3. Ask user: **Supervised or Autonomous?**

## Execution Mode Selection

**Recommend Subagent-Driven** (superpowers:subagent-driven-development)

| Level | Description |
|-------|-------------|
| **Supervised** | Claude may ask questions, user reviews progress |
| **Autonomous** | No questions, auto-decide, unattended execution |

### Supervised Mode

Proceed with `subagent-driven-development` directly.

### Autonomous Mode (ralph-loop)

```text
/ralph-loop "Execute the plan using subagent-driven-development skill. Do NOT ask questions - make reasonable decisions and proceed. When ALL tasks complete, output: <promise>ALL_TASKS_COMPLETE</promise>" --max-iterations 50 --completion-promise "ALL_TASKS_COMPLETE"
```

**After loop completes:** User returns for FINISH stage (merge/PR choice)

## Checkpoint

Before marking execution complete, verify:

- [ ] All tasks in plan.md marked complete
- [ ] All phases in task_plan.md marked complete
