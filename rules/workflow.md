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
3. Ask user: **Subagent-Driven or Parallel Session?**

## Execution Mode Selection

### Step 1: Choose Execution Style

| Mode | Description |
|------|-------------|
| **Subagent-Driven** | Same session, fresh subagent per task, auto review |
| **Parallel Session** | New session with executing-plans, batch checkpoints |

Recommend: **Subagent-Driven** (faster, no context switch)

### Step 2: If Subagent-Driven, Choose Supervision Level

| Level | Description |
|-------|-------------|
| **Supervised** | Claude may ask questions, user reviews progress |
| **Autonomous** | No questions, auto-decide, unattended execution |

If **Autonomous** chosen, use ralph-loop:

```text
/ralph-loop "Execute the plan using subagent-driven-development skill. Do NOT ask questions - make reasonable decisions and proceed. When ALL tasks complete, output: <promise>ALL_TASKS_COMPLETE</promise>" --max-iterations 50 --completion-promise "ALL_TASKS_COMPLETE"
```

## Checkpoint

Before marking execution complete, verify:

- [ ] All tasks in plan.md marked complete
- [ ] All phases in task_plan.md marked complete
