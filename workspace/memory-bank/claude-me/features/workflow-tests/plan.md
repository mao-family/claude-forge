# Workflow Tests Implementation Plan

<!-- markdownlint-disable MD036 -- superpowers plan format uses **Step N:** -->

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Create comprehensive automated tests for workflow rules using Bats framework.

**Architecture:** Helper functions in separate file, main test file organized by test groups, uses `claude --print` for Claude interaction testing.

**Tech Stack:** Bats, Bash, Claude CLI

---

## Task 1: Create Helper Functions

**Files:**

- Create: `tests/workflow-helpers.bash`

**Step 1: Write helper functions**

```bash
#!/usr/bin/env bash
# Helper functions for workflow tests

# Run claude with timeout and capture output
run_claude() {
  local prompt="$1"
  local timeout="${2:-120}"
  timeout "${timeout}" claude --print "${prompt}" 2>&1
}

# Assert output contains keyword
assert_contains() {
  local output="$1"
  local keyword="$2"
  if [[ "${output}" != *"${keyword}"* ]]; then
    echo "Expected output to contain: ${keyword}"
    echo "Actual output: ${output}"
    return 1
  fi
}

# Assert output does not contain keyword
assert_not_contains() {
  local output="$1"
  local keyword="$2"
  if [[ "${output}" == *"${keyword}"* ]]; then
    echo "Expected output NOT to contain: ${keyword}"
    echo "Actual output: ${output}"
    return 1
  fi
}

# Setup test project directory
setup_test_project() {
  local name="$1"
  local dir="/tmp/workflow-test-${name}-$$"
  mkdir -p "${dir}"
  cd "${dir}" || return 1
  git init
  echo "# Test Project" > README.md
  git add README.md
  git commit -m "init"
  echo "${dir}"
}

# Cleanup test project
cleanup_test_project() {
  local dir="$1"
  if [[ -d "${dir}" && "${dir}" == /tmp/workflow-test-* ]]; then
    rm -rf "${dir}"
  fi
}

# Check if file exists
assert_file_exists() {
  local path="$1"
  if [[ ! -f "${path}" ]]; then
    echo "Expected file to exist: ${path}"
    return 1
  fi
}

# Check if directory exists
assert_dir_exists() {
  local path="$1"
  if [[ ! -d "${path}" ]]; then
    echo "Expected directory to exist: ${path}"
    return 1
  fi
}

# Check git branch exists
assert_branch_exists() {
  local branch="$1"
  if ! git branch --list "${branch}" | grep -q "${branch}"; then
    echo "Expected branch to exist: ${branch}"
    return 1
  fi
}

# Check worktree exists
assert_worktree_exists() {
  local path="$1"
  if ! git worktree list | grep -q "${path}"; then
    echo "Expected worktree to exist: ${path}"
    return 1
  fi
}
```

**Step 2: Make file executable**

Run: `chmod +x tests/workflow-helpers.bash`

**Step 3: Commit**

```bash
git add tests/workflow-helpers.bash
git commit -m "feat: add workflow test helper functions"
```

---

## Task 2: Create Test File Structure

**Files:**

- Create: `tests/workflow.bats`

**Step 1: Write test file skeleton**

```bash
#!/usr/bin/env bats

# Load test helpers
load 'workflow-helpers.bash'

# Setup before all tests
setup_file() {
  export TEST_DIR="/tmp/workflow-tests-$$"
  mkdir -p "${TEST_DIR}"
}

# Teardown after all tests
teardown_file() {
  if [[ -d "${TEST_DIR}" ]]; then
    rm -rf "${TEST_DIR}"
  fi
}

# Setup before each test
setup() {
  cd "${TEST_DIR}" || return 1
}

# =============================================================================
# CONSTRAINT TESTS: BRAINSTORM (B1-B4)
# =============================================================================

# B1: Direct coding request without BRAINSTORM
@test "B1: rejects direct coding without BRAINSTORM" {
  skip "TODO: implement"
}

# B2: Function writing request without BRAINSTORM
@test "B2: rejects function writing without BRAINSTORM" {
  skip "TODO: implement"
}

# B3: Skip design request
@test "B3: rejects skip design request" {
  skip "TODO: implement"
}

# B4: Idea implementation triggers brainstorming
@test "B4: idea implementation invokes brainstorming" {
  skip "TODO: implement"
}

# =============================================================================
# CONSTRAINT TESTS: WORKTREE (W1-W3)
# =============================================================================

# W1: Skip worktree after BRAINSTORM
@test "W1: rejects skipping worktree after BRAINSTORM" {
  skip "TODO: implement"
}

# W2: Explicit skip worktree request
@test "W2: rejects explicit skip worktree" {
  skip "TODO: implement"
}

# W3: Direct development on main branch
@test "W3: rejects development on main branch" {
  skip "TODO: implement"
}

# =============================================================================
# CONSTRAINT TESTS: PLAN (P1-P3)
# =============================================================================

# P1: No plan, direct coding
@test "P1: rejects coding without plan" {
  skip "TODO: implement"
}

# P2: Skip plan stage
@test "P2: rejects skip plan stage" {
  skip "TODO: implement"
}

# P3: Start implementation without plan.md
@test "P3: rejects implementation without plan.md" {
  skip "TODO: implement"
}

# =============================================================================
# CONSTRAINT TESTS: EXECUTE (E1-E5)
# =============================================================================

# E1: Correct execution flow
@test "E1: execute invokes /plan then subagent-driven-development" {
  skip "TODO: implement"
}

# E2: Direct coding without subagent
@test "E2: rejects direct coding without subagent skill" {
  skip "TODO: implement"
}

# E3: Skip planning-with-files
@test "E3: rejects skipping planning-with-files" {
  skip "TODO: implement"
}

# E4: Task completion check
@test "E4: verifies all tasks marked complete" {
  skip "TODO: implement"
}

# E5: Partial tasks block REVIEW
@test "E5: incomplete tasks block REVIEW" {
  skip "TODO: implement"
}

# =============================================================================
# CONSTRAINT TESTS: REVIEW (R1-R3)
# =============================================================================

# R1: Direct commit without REVIEW
@test "R1: rejects direct commit without REVIEW" {
  skip "TODO: implement"
}

# R2: Skip code review
@test "R2: rejects skip code review" {
  skip "TODO: implement"
}

# R3: Continue with Critical issues
@test "R3: rejects continue with Critical issues" {
  skip "TODO: implement"
}

# =============================================================================
# SKILL INVOCATION TESTS (S1-S6)
# =============================================================================

# S1: Start feature invokes brainstorming
@test "S1: start feature invokes brainstorming" {
  skip "TODO: implement"
}

# S2: After design invokes using-git-worktrees
@test "S2: after design invokes using-git-worktrees" {
  skip "TODO: implement"
}

# S3: After worktree invokes writing-plans
@test "S3: after worktree invokes writing-plans" {
  skip "TODO: implement"
}

# S4: After plan invokes /plan and subagent-driven-development
@test "S4: after plan invokes subagent-driven-development" {
  skip "TODO: implement"
}

# S5: After execute invokes code-reviewer
@test "S5: after execute invokes code-reviewer" {
  skip "TODO: implement"
}

# S6: After review invokes finishing-a-development-branch
@test "S6: after review invokes finishing-a-development-branch" {
  skip "TODO: implement"
}

# =============================================================================
# FILE TESTS (F1-F5, A1-A3)
# =============================================================================

# F1: design.md created in correct location
@test "F1: design.md created in memory-bank" {
  skip "TODO: implement"
}

# F2: plan.md created in correct location
@test "F2: plan.md created in memory-bank" {
  skip "TODO: implement"
}

# F3: task_plan.md created in worktree
@test "F3: task_plan.md created in worktree" {
  skip "TODO: implement"
}

# F4: findings.md created in worktree
@test "F4: findings.md created in worktree" {
  skip "TODO: implement"
}

# F5: progress.md created in worktree
@test "F5: progress.md created in worktree" {
  skip "TODO: implement"
}

# A1: task_plan.md archived
@test "A1: task_plan.md archived to memory-bank" {
  skip "TODO: implement"
}

# A2: findings.md archived
@test "A2: findings.md archived to memory-bank" {
  skip "TODO: implement"
}

# A3: progress.md archived
@test "A3: progress.md archived to memory-bank" {
  skip "TODO: implement"
}

# =============================================================================
# GIT TESTS (G1-G6)
# =============================================================================

# G1: Feature branch created
@test "G1: feature branch created after BRAINSTORM" {
  skip "TODO: implement"
}

# G2: design.md committed
@test "G2: design.md committed" {
  skip "TODO: implement"
}

# G3: plan.md committed
@test "G3: plan.md committed" {
  skip "TODO: implement"
}

# G4: Worktree created
@test "G4: worktree created" {
  skip "TODO: implement"
}

# G5: Archive commit created
@test "G5: archive commit created" {
  skip "TODO: implement"
}

# G6: Worktree cleaned up
@test "G6: worktree cleaned up after FINISH" {
  skip "TODO: implement"
}

# =============================================================================
# HOOK TESTS (H1-H3)
# =============================================================================

# H1: PreToolUse reads task_plan.md
@test "H1: PreToolUse reads task_plan.md" {
  skip "TODO: implement"
}

# H2: PostToolUse prompts update
@test "H2: PostToolUse prompts update" {
  skip "TODO: implement"
}

# H3: Session resume loads context
@test "H3: session resume loads context" {
  skip "TODO: implement"
}

# =============================================================================
# SUBAGENT TESTS (SA1-SA5)
# =============================================================================

# SA1: Fresh subagent per task
@test "SA1: fresh subagent per task" {
  skip "TODO: implement"
}

# SA2: Spec review after task
@test "SA2: spec review after task" {
  skip "TODO: implement"
}

# SA3: Quality review after spec
@test "SA3: quality review after spec pass" {
  skip "TODO: implement"
}

# SA4: Final review after all tasks
@test "SA4: final review after all tasks" {
  skip "TODO: implement"
}

# SA5: Autonomous mode no questions
@test "SA5: autonomous mode does not ask questions" {
  skip "TODO: implement"
}

# =============================================================================
# CODE-REVIEWER TESTS (CR1-CR4)
# =============================================================================

# CR1: Reviews against plan
@test "CR1: code-reviewer compares with plan" {
  skip "TODO: implement"
}

# CR2: Critical issues block FINISH
@test "CR2: Critical issues block FINISH" {
  skip "TODO: implement"
}

# CR3: Important issues allow continue
@test "CR3: Important issues allow continue with warning" {
  skip "TODO: implement"
}

# CR4: No issues passes
@test "CR4: no issues passes review" {
  skip "TODO: implement"
}

# =============================================================================
# FINISH OPTIONS TESTS (FO1-FO4)
# =============================================================================

# FO1: Merge locally
@test "FO1: merge locally option works" {
  skip "TODO: implement"
}

# FO2: Create PR
@test "FO2: create PR option works" {
  skip "TODO: implement"
}

# FO3: Keep as-is
@test "FO3: keep as-is preserves worktree" {
  skip "TODO: implement"
}

# FO4: Discard
@test "FO4: discard removes branch and worktree" {
  skip "TODO: implement"
}

# =============================================================================
# ERROR RECOVERY TESTS (ER1-ER3)
# =============================================================================

# ER1: Resume after interrupt
@test "ER1: resume after interrupt loads state" {
  skip "TODO: implement"
}

# ER2: EXECUTE interrupted
@test "ER2: EXECUTE interrupted preserves progress" {
  skip "TODO: implement"
}

# ER3: 3-Strike escalation
@test "ER3: 3-Strike failure escalates to user" {
  skip "TODO: implement"
}

# =============================================================================
# ORDER/PATH TESTS (O1-O2, M1-M2)
# =============================================================================

# O1: Stage order violation
@test "O1: rejects skipping stages" {
  skip "TODO: implement"
}

# O2: Stage rollback
@test "O2: stage rollback behavior" {
  skip "TODO: implement"
}

# M1: memory-bank path correctness
@test "M1: memory-bank path uses correct variables" {
  skip "TODO: implement"
}

# M2: Multi-project isolation
@test "M2: multi-project files are isolated" {
  skip "TODO: implement"
}

# =============================================================================
# PLANNING-WITH-FILES TESTS (PF1-PF3)
# =============================================================================

# PF1: 2-Action Rule
@test "PF1: 2-Action Rule saves findings" {
  skip "TODO: implement"
}

# PF2: 3-Strike Protocol
@test "PF2: 3-Strike Protocol escalates" {
  skip "TODO: implement"
}

# PF3: Read Before Decide
@test "PF3: reads task_plan before decisions" {
  skip "TODO: implement"
}
```

**Step 2: Make file executable**

Run: `chmod +x tests/workflow.bats`

**Step 3: Commit**

```bash
git add tests/workflow.bats
git commit -m "feat: add workflow test structure with 64 test cases"
```

---

## Task 3: Implement BRAINSTORM Constraint Tests (B1-B4)

**Files:**

- Modify: `tests/workflow.bats`

**Step 1: Implement B1 test**

Replace the B1 test with:

```bash
# B1: Direct coding request without BRAINSTORM
@test "B1: rejects direct coding without BRAINSTORM" {
  run run_claude "直接写代码实现一个用户登录功能"

  # Should mention brainstorming or reject
  assert_contains "${output}" "brainstorming" || \
  assert_contains "${output}" "BRAINSTORM" || \
  assert_contains "${output}" "MUST"
}
```

**Step 2: Implement B2 test**

```bash
# B2: Function writing request without BRAINSTORM
@test "B2: rejects function writing without BRAINSTORM" {
  run run_claude "帮我写一个函数计算斐波那契数列"

  assert_contains "${output}" "brainstorming" || \
  assert_contains "${output}" "BRAINSTORM"
}
```

**Step 3: Implement B3 test**

```bash
# B3: Skip design request
@test "B3: rejects skip design request" {
  run run_claude "跳过设计阶段，直接开始编码"

  assert_contains "${output}" "MUST" || \
  assert_contains "${output}" "cannot skip" || \
  assert_contains "${output}" "BRAINSTORM"
}
```

**Step 4: Implement B4 test**

```bash
# B4: Idea implementation triggers brainstorming
@test "B4: idea implementation invokes brainstorming" {
  run run_claude "我有个想法，做一个任务管理系统"

  assert_contains "${output}" "brainstorming" || \
  assert_contains "${output}" "Using brainstorming"
}
```

**Step 5: Run tests to verify**

Run: `bats tests/workflow.bats --filter "B[1-4]"`

**Step 6: Commit**

```bash
git add tests/workflow.bats
git commit -m "feat: implement BRAINSTORM constraint tests (B1-B4)"
```

---

## Task 4: Implement WORKTREE Constraint Tests (W1-W3)

**Files:**

- Modify: `tests/workflow.bats`

**Step 1: Implement W1-W3 tests**

Replace W1-W3 tests with actual implementations testing worktree constraints.

**Step 2: Run tests**

Run: `bats tests/workflow.bats --filter "W[1-3]"`

**Step 3: Commit**

```bash
git add tests/workflow.bats
git commit -m "feat: implement WORKTREE constraint tests (W1-W3)"
```

---

## Task 5: Implement PLAN Constraint Tests (P1-P3)

**Files:**

- Modify: `tests/workflow.bats`

**Step 1: Implement P1-P3 tests**

**Step 2: Run tests**

Run: `bats tests/workflow.bats --filter "P[1-3]"`

**Step 3: Commit**

```bash
git add tests/workflow.bats
git commit -m "feat: implement PLAN constraint tests (P1-P3)"
```

---

## Task 6: Implement EXECUTE Constraint Tests (E1-E5)

**Files:**

- Modify: `tests/workflow.bats`

**Step 1: Implement E1-E5 tests**

**Step 2: Run tests**

Run: `bats tests/workflow.bats --filter "E[1-5]"`

**Step 3: Commit**

```bash
git add tests/workflow.bats
git commit -m "feat: implement EXECUTE constraint tests (E1-E5)"
```

---

## Task 7: Implement REVIEW Constraint Tests (R1-R3)

**Files:**

- Modify: `tests/workflow.bats`

**Step 1: Implement R1-R3 tests**

**Step 2: Run tests**

Run: `bats tests/workflow.bats --filter "R[1-3]"`

**Step 3: Commit**

```bash
git add tests/workflow.bats
git commit -m "feat: implement REVIEW constraint tests (R1-R3)"
```

---

## Task 8: Implement Skill Invocation Tests (S1-S6)

**Files:**

- Modify: `tests/workflow.bats`

**Step 1: Implement S1-S6 tests**

**Step 2: Run tests**

Run: `bats tests/workflow.bats --filter "S[1-6]"`

**Step 3: Commit**

```bash
git add tests/workflow.bats
git commit -m "feat: implement skill invocation tests (S1-S6)"
```

---

## Task 9: Implement File Tests (F1-F5, A1-A3)

**Files:**

- Modify: `tests/workflow.bats`

**Step 1: Implement F1-F5 and A1-A3 tests**

**Step 2: Run tests**

Run: `bats tests/workflow.bats --filter "[FA][1-5]"`

**Step 3: Commit**

```bash
git add tests/workflow.bats
git commit -m "feat: implement file creation and archiving tests"
```

---

## Task 10: Implement Git Tests (G1-G6)

**Files:**

- Modify: `tests/workflow.bats`

**Step 1: Implement G1-G6 tests**

**Step 2: Run tests**

Run: `bats tests/workflow.bats --filter "G[1-6]"`

**Step 3: Commit**

```bash
git add tests/workflow.bats
git commit -m "feat: implement git operation tests (G1-G6)"
```

---

## Task 11: Implement Remaining Tests

**Files:**

- Modify: `tests/workflow.bats`

**Step 1: Implement Hook tests (H1-H3)**

**Step 2: Implement Subagent tests (SA1-SA5)**

**Step 3: Implement code-reviewer tests (CR1-CR4)**

**Step 4: Implement FINISH options tests (FO1-FO4)**

**Step 5: Implement Error recovery tests (ER1-ER3)**

**Step 6: Implement Order/path tests (O1-O2, M1-M2)**

**Step 7: Implement planning-with-files tests (PF1-PF3)**

**Step 8: Run all tests**

Run: `bats tests/workflow.bats`

**Step 9: Commit**

```bash
git add tests/workflow.bats
git commit -m "feat: implement remaining workflow tests"
```

---

## Task 12: Final Verification

**Step 1: Run full test suite**

Run: `bats tests/workflow.bats --tap`

**Step 2: Verify test count**

Expected: 64 tests

**Step 3: Document any skipped tests**

If any tests cannot be automated, document why.

**Step 4: Final commit**

```bash
git add -A
git commit -m "docs: finalize workflow tests documentation"
```
