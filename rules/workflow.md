# Workflow Rules

## Mandatory Workflow

**ALL feature development MUST follow superpowers workflow:**

```text
BRAINSTORM → WORKTREE → PLAN → EXECUTE → REVIEW → FINISH
     1           2         3        4         5        6
```

## Stage Requirements

| # | Stage | Skill/Agent | Gate |
|---|-------|-------------|------|
| 1 | BRAINSTORM | `brainstorming` | Design approved, feature branch created |
| 2 | WORKTREE | `using-git-worktrees` | Worktree created |
| 3 | PLAN | `writing-plans` | plan.md saved |
| 4 | EXECUTE | `subagent-driven-development` | All tasks complete |
| 5 | REVIEW | `code-reviewer` agent | Review passed |
| 6 | FINISH | `finishing-a-development-branch` | Merge/PR done, files archived |

**Gate = Must be satisfied before proceeding to next stage.**

## Forbidden Actions

| Action | Why Forbidden |
|--------|---------------|
| Code before PLAN complete | No plan.md = no coding |
| Skip feature branch | Must create feature branch after BRAINSTORM |
| Skip WORKTREE | Must isolate feature work |
| Execute without skill | Must invoke `subagent-driven-development` |
| Skip REVIEW | Must use `code-reviewer` agent after EXECUTE |
| Skip FINISH skill | Must use `finishing-a-development-branch` |
| Skip any stage | All 6 stages are mandatory |

## Key Constraints

### After BRAINSTORM Approval

1. Create feature branch: `git checkout -b feature/{name}`
2. Save design.md to: `workspace/memory-bank/{project}/features/{name}/`
3. Commit

### After PLAN Approval

1. Save plan.md to: `workspace/memory-bank/{project}/features/{name}/`
2. Commit

### Before EXECUTE

**MUST** run `/plan` to initialize planning-with-files.

### Execution Mode

| Mode | How |
|------|-----|
| Supervised | Invoke `subagent-driven-development` directly |
| Autonomous | `/ralph-loop` with `subagent-driven-development` |

### After EXECUTE

**MUST** invoke `code-reviewer` agent. All Critical issues must be fixed.

### After FINISH

**MUST** archive planning-with-files to `memory-bank/{project}/features/{name}/`.

## Stage Checklist

- [ ] **BRAINSTORM**: Design approved, feature branch created
- [ ] **WORKTREE**: Working in isolated worktree
- [ ] **PLAN**: Plan approved, plan.md saved
- [ ] **EXECUTE**: All tasks complete
- [ ] **REVIEW**: No Critical issues
- [ ] **FINISH**: Merge/PR done, files archived, worktree cleaned

## Related Documentation

See [memory-bank/workflow.md](../memory-bank/workflow.md) for detailed stage descriptions.
