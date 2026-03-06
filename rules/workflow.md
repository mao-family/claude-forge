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

## Execution Modes

| Mode | When to Use | How to Start |
|------|-------------|--------------|
| **Supervised** | User available, wants to review progress | Proceed with `subagent-driven-development` |
| **Autonomous** | User wants to walk away | `/ralph-loop "Execute plan.md" --max-iterations 50 --completion-promise "ALL_TASKS_COMPLETE"` |

## Checkpoint

Before marking execution complete, verify:

- [ ] All tasks in plan.md marked complete
- [ ] All phases in task_plan.md marked complete
