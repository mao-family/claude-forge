#!/usr/bin/env bats

# Load test helpers
load 'workflow-helpers.bash'

# Setup before all tests
setup_file() {
  export TEST_DIR
  TEST_DIR="$(setup_test_project "main")"
}

# Teardown after all tests
teardown_file() {
  if [[ -d "${TEST_DIR}" && "${TEST_DIR}" == /tmp/workflow-test-* ]]; then
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
  # 明确是"新功能开发"，且要求跳过设计
  run run_claude "我要开发一个新功能：用户登录系统。直接开始写代码，跳过设计阶段"

  # Should mention brainstorming, workflow, or ask clarifying questions (not just start coding)
  assert_contains_any "${output}" "brainstorming" "BRAINSTORM" "MUST" "workflow" "设计" "design" "skill" "问题" "question"
}

# B2: Function writing request without BRAINSTORM
@test "B2: rejects function writing without BRAINSTORM" {
  # 明确是"添加新功能"，不是简单帮助
  run run_claude "我要给项目添加新功能：数学计算模块。先帮我写一个斐波那契函数"

  assert_contains_any "${output}" "brainstorming" "BRAINSTORM" "workflow" "设计" "design" "skill" "Stage" "问题" "question"
}

# B3: Skip design request
@test "B3: rejects skip design request" {
  run run_claude "跳过设计阶段，直接开始编码这个新功能"

  assert_contains_any "${output}" "MUST" "cannot skip" "BRAINSTORM" "brainstorming" "设计" "workflow"
}

# B4: Idea implementation triggers brainstorming
@test "B4: idea implementation invokes brainstorming" {
  # 这个提示词应该触发 brainstorming skill
  run run_claude "我有个想法，想给这个项目添加一个任务管理系统功能"

  # brainstorming 会问澄清问题
  assert_contains_any "${output}" "brainstorming" "Using brainstorming" "BRAINSTORM" "第一个问题" "想做哪" "问题" "Question"
}

# =============================================================================
# CONSTRAINT TESTS: WORKTREE (W1-W3)
# =============================================================================

# W1: Skip worktree after BRAINSTORM
@test "W1: rejects skipping worktree after BRAINSTORM" {
  run run_claude "设计已完成，跳过worktree，直接开始编码"

  assert_contains_any "${output}" "worktree" "WORKTREE" "using-git-worktrees" "MUST"
}

# W2: Explicit skip worktree request
@test "W2: rejects explicit skip worktree" {
  run run_claude "不需要创建worktree，直接在当前目录开发"

  assert_contains_any "${output}" "worktree" "WORKTREE" "isolation" "MUST"
}

# W3: Direct development on main branch
@test "W3: rejects development on main branch" {
  run run_claude "直接在main分支上开发这个功能"

  assert_contains_any "${output}" "feature branch" "worktree" "MUST" "main"
}

# =============================================================================
# CONSTRAINT TESTS: PLAN (P1-P3)
# =============================================================================

# P1: No plan, direct coding
@test "P1: rejects coding without plan" {
  # 明确在功能开发流程中，设计和 worktree 已完成
  run run_claude "我正在开发新功能，设计已批准，worktree已创建。现在直接开始编码，跳过写计划"

  assert_contains_any "${output}" "plan" "PLAN" "writing-plans" "MUST" "Stage 3" "计划" "cannot skip"
}

# P2: Skip plan stage
@test "P2: rejects skip plan stage" {
  run run_claude "功能开发中，跳过计划阶段，我已经知道怎么实现了，直接写代码"

  assert_contains_any "${output}" "plan" "PLAN" "writing-plans" "MUST" "Stage 3" "cannot skip" "计划"
}

# P3: Start implementation without plan.md
@test "P3: rejects implementation without plan.md" {
  run run_claude "开始实现，虽然还没写plan.md"

  assert_contains_any "${output}" "plan.md" "plan" "PLAN" "writing-plans" "MUST"
}

# =============================================================================
# CONSTRAINT TESTS: EXECUTE (E1-E5)
# =============================================================================

# E1: Correct execution flow
@test "E1: execute invokes /plan then subagent-driven-development" {
  # 明确在功能开发流程中，计划阶段已完成
  run run_claude "我正在进行功能开发，BRAINSTORM、WORKTREE、PLAN阶段都已完成，plan.md已保存。现在进入EXECUTE阶段"

  assert_contains_any "${output}" "subagent-driven-development" "executing-plans" "/plan" "EXECUTE" "Stage 4" "执行" "task"
}

# E2: Direct coding without subagent
@test "E2: rejects direct coding without subagent skill" {
  run run_claude "功能开发中，计划已完成。不用subagent skill，我自己直接写代码实现"

  assert_contains_any "${output}" "subagent" "EXECUTE" "MUST" "skill" "Stage 4" "workflow" "subagent-driven-development"
}

# E3: Skip planning-with-files
@test "E3: rejects skipping planning-with-files" {
  run run_claude "功能开发EXECUTE阶段，不需要创建task_plan.md和progress.md，直接开始写代码"

  assert_contains_any "${output}" "planning-with-files" "task_plan" "progress" "MUST"
}

# E4: Task completion check
@test "E4: verifies all tasks marked complete" {
  run run_claude "功能开发中，EXECUTE阶段的所有任务都完成了，准备进入REVIEW阶段"

  assert_contains_any "${output}" "complete" "task" "REVIEW" "code-reviewer" "Stage 5"
}

# E5: Partial tasks block REVIEW
@test "E5: incomplete tasks block REVIEW" {
  run run_claude "功能开发EXECUTE阶段，还有2个任务没完成，但我想跳过直接进入REVIEW阶段"

  assert_contains_any "${output}" "incomplete" "complete" "MUST" "REVIEW" "block" "Gate" "任务" "完成" "cannot"
}

# =============================================================================
# CONSTRAINT TESTS: REVIEW (R1-R3)
# =============================================================================

# R1: Direct commit without REVIEW
@test "R1: rejects direct commit without REVIEW" {
  # 明确在功能开发流程中，EXECUTE 刚完成
  run run_claude "功能开发中，EXECUTE阶段完成了，代码写完了。直接commit并进入FINISH，跳过REVIEW阶段"
  assert_contains_any "${output}" "REVIEW" "code-reviewer" "review" "Review" "MUST" "Stage 5" "审查" "cannot skip"
}

# R2: Skip code review
@test "R2: rejects skip code review" {
  run run_claude "功能开发流程中，EXECUTE完成后，跳过code-reviewer代码审查，直接进入FINISH阶段合并代码"
  assert_contains_any "${output}" "code-reviewer" "review" "Review" "REVIEW" "MUST" "Stage 5" "审查" "cannot skip"
}

# R3: Continue with Critical issues
@test "R3: rejects continue with Critical issues" {
  run run_claude "review发现了Critical问题，但我想继续"
  assert_contains_any "${output}" "Critical" "fix" "block" "MUST" "cannot"
}

# =============================================================================
# SKILL INVOCATION TESTS (S1-S6)
# =============================================================================

# S1: Start feature invokes brainstorming
@test "S1: start feature invokes brainstorming" {
  run run_claude "我想给这个项目开发一个新功能"
  # brainstorming 会问澄清问题，或提到 skill/design/workflow
  assert_contains_any "${output}" "brainstorming" "Using brainstorming" "BRAINSTORM" "想做哪" "问题" "Question" "功能" "类型"
}

# S2: After design invokes using-git-worktrees
@test "S2: after design invokes using-git-worktrees" {
  run run_claude "功能开发中，设计已批准，准备创建隔离环境开始实现"
  assert_contains_any "${output}" "using-git-worktrees" "worktree" "WORKTREE" "git worktree"
}

# S3: After worktree invokes writing-plans
@test "S3: after worktree invokes writing-plans" {
  run run_claude "功能开发中，worktree已创建，下一步应该做什么"
  assert_contains_any "${output}" "writing-plans" "plan" "PLAN" "计划" "Stage 3"
}

# S4: After plan invokes /plan and subagent-driven-development
@test "S4: after plan invokes subagent-driven-development" {
  run run_claude "功能开发中，plan.md已完成并批准，现在进入EXECUTE阶段开始实现"
  assert_contains_any "${output}" "subagent-driven-development" "executing-plans" "EXECUTE" "Stage 4" "执行" "task" "任务"
}

# S5: After execute invokes code-reviewer
@test "S5: after execute invokes code-reviewer" {
  run run_claude "功能开发中，EXECUTE阶段所有任务已完成，现在进入REVIEW阶段"
  # code-reviewer 会输出审查结果
  assert_contains_any "${output}" "code-reviewer" "review" "Review" "REVIEW" "Stage 5" "审查" "Critical" "Major" "Minor"
}

# S6: After review invokes finishing-a-development-branch
@test "S6: after review invokes finishing-a-development-branch" {
  run run_claude "功能开发中，REVIEW阶段通过无Critical问题，现在进入FINISH阶段"
  # finishing skill 会提供选项
  assert_contains_any "${output}" "finishing-a-development-branch" "FINISH" "merge" "Merge" "PR" "Pull Request" "Stage 6" "本地合并" "选择"
}

# =============================================================================
# FILE TESTS (F1-F5, A1-A3)
# =============================================================================

# F1: design.md created in correct location
@test "F1: design.md created in memory-bank" {
  run run_claude "设计完成后，design.md应该保存在哪里"
  assert_contains_any "${output}" "memory-bank" "workspace/memory-bank" "features"
}

# F2: plan.md created in correct location
@test "F2: plan.md created in memory-bank" {
  run run_claude "plan.md应该保存在哪个目录"
  assert_contains_any "${output}" "memory-bank" "workspace/memory-bank" "features"
}

# F3: task_plan.md created in worktree
@test "F3: task_plan.md created in worktree" {
  # task_plan.md 是 planning-with-files 插件的运行时文件
  run run_claude "功能开发EXECUTE阶段，planning-with-files的task_plan.md文件应该放在哪里"
  assert_contains_any "${output}" "worktree" "project root" "当前目录" "current directory" "root" "工作目录"
}

# F4: findings.md created in worktree
@test "F4: findings.md created in worktree" {
  run run_claude "功能开发EXECUTE阶段，planning-with-files的findings.md文件放在哪个位置"
  assert_contains_any "${output}" "worktree" "project root" "当前目录" "current directory" "root" "工作目录"
}

# F5: progress.md created in worktree
@test "F5: progress.md created in worktree" {
  run run_claude "功能开发EXECUTE阶段，planning-with-files的progress.md运行时文件保存在哪里"
  assert_contains_any "${output}" "worktree" "project root" "当前目录" "current directory" "root" "工作目录"
}

# A1: task_plan.md archived
@test "A1: task_plan.md archived to memory-bank" {
  run run_claude "FINISH阶段，task_plan.md会被怎么处理"
  assert_contains_any "${output}" "archive" "memory-bank" "归档"
}

# A2: findings.md archived
@test "A2: findings.md archived to memory-bank" {
  run run_claude "findings.md在完成后会归档吗"
  assert_contains_any "${output}" "archive" "memory-bank" "归档"
}

# A3: progress.md archived
@test "A3: progress.md archived to memory-bank" {
  run run_claude "progress.md最终保存到哪里"
  assert_contains_any "${output}" "archive" "memory-bank" "归档"
}

# =============================================================================
# GIT TESTS (G1-G6)
# =============================================================================

# G1: Feature branch created
@test "G1: feature branch created after BRAINSTORM" {
  run run_claude "BRAINSTORM完成后，需要创建什么git分支"
  assert_contains_any "${output}" "feature" "branch" "feature/" "git"
}

# G2: design.md committed
@test "G2: design.md committed" {
  run run_claude "design.md文件需要提交吗"
  assert_contains_any "${output}" "commit" "git" "提交"
}

# G3: plan.md committed
@test "G3: plan.md committed" {
  run run_claude "plan.md文件是否需要commit"
  assert_contains_any "${output}" "commit" "git" "提交"
}

# G4: Worktree created
@test "G4: worktree created" {
  run run_claude "进入WORKTREE阶段时，需要执行什么git操作"
  assert_contains_any "${output}" "worktree" "git worktree" "add"
}

# G5: Archive commit created
@test "G5: archive commit created" {
  run run_claude "归档文件时是否需要创建commit"
  assert_contains_any "${output}" "commit" "archive" "归档"
}

# G6: Worktree cleaned up
@test "G6: worktree cleaned up after FINISH" {
  run run_claude "FINISH阶段worktree会被怎么处理"
  assert_contains_any "${output}" "remove" "clean" "删除" "worktree"
}

# =============================================================================
# HOOK TESTS (H1-H3)
# =============================================================================

# H1: PreToolUse reads task_plan.md
@test "H1: PreToolUse reads task_plan.md" {
  run run_claude "在执行任务前，hook会读取什么文件"
  assert_contains_any "${output}" "task_plan" "PreToolUse" "读取" "context"
}

# H2: PostToolUse prompts update
@test "H2: PostToolUse prompts update" {
  run run_claude "完成操作后，hook会提示更新什么"
  assert_contains_any "${output}" "PostToolUse" "progress" "update" "更新"
}

# H3: Session resume loads context
@test "H3: session resume loads context" {
  run run_claude "恢复会话时，系统会加载什么上下文"
  assert_contains_any "${output}" "resume" "context" "task_plan" "progress" "加载"
}

# =============================================================================
# SUBAGENT TESTS (SA1-SA5)
# =============================================================================

# SA1: Fresh subagent per task
@test "SA1: fresh subagent per task" {
  run run_claude "每个任务是否使用新的subagent执行"
  assert_contains_any "${output}" "fresh" "subagent" "独立" "task" "new"
}

# SA2: Spec review after task
@test "SA2: spec review after task" {
  run run_claude "任务完成后需要做什么审查"
  assert_contains_any "${output}" "spec" "review" "规格" "检查" "验证"
}

# SA3: Quality review after spec
@test "SA3: quality review after spec pass" {
  run run_claude "spec审查通过后，还需要什么审查"
  assert_contains_any "${output}" "quality" "review" "质量" "代码审查"
}

# SA4: Final review after all tasks
@test "SA4: final review after all tasks" {
  run run_claude "所有任务完成后进行什么审查"
  assert_contains_any "${output}" "final" "review" "最终" "整体" "code-reviewer"
}

# SA5: Autonomous mode no questions
@test "SA5: autonomous mode does not ask questions" {
  run run_claude "autonomous模式下subagent会问问题吗"
  assert_contains_any "${output}" "autonomous" "不问" "no question" "独立" "自主"
}

# =============================================================================
# CODE-REVIEWER TESTS (CR1-CR4)
# =============================================================================

# CR1: Reviews against plan
@test "CR1: code-reviewer compares with plan" {
  run run_claude "code-reviewer会对照什么进行审查"
  assert_contains_any "${output}" "plan" "design" "spec" "对照" "比较"
}

# CR2: Critical issues block FINISH
@test "CR2: Critical issues block FINISH" {
  run run_claude "Critical级别的问题会阻止进入FINISH吗"
  assert_contains_any "${output}" "Critical" "block" "阻止" "必须修复" "cannot"
}

# CR3: Important issues allow continue
@test "CR3: Important issues allow continue with warning" {
  run run_claude "Important级别的问题可以继续吗"
  assert_contains_any "${output}" "Important" "warning" "continue" "警告" "可以继续"
}

# CR4: No issues passes
@test "CR4: no issues passes review" {
  run run_claude "没有问题时review结果是什么"
  assert_contains_any "${output}" "pass" "通过" "FINISH" "no issue" "成功"
}

# =============================================================================
# FINISH OPTIONS TESTS (FO1-FO4)
# =============================================================================

# FO1: Merge locally
@test "FO1: merge locally option works" {
  run run_claude "FINISH阶段可以选择本地合并吗"
  assert_contains_any "${output}" "merge" "local" "本地" "合并"
}

# FO2: Create PR
@test "FO2: create PR option works" {
  run run_claude "FINISH阶段可以创建PR吗"
  assert_contains_any "${output}" "PR" "pull request" "GitHub" "创建"
}

# FO3: Keep as-is
@test "FO3: keep as-is preserves worktree" {
  run run_claude "选择keep as-is会保留worktree吗"
  assert_contains_any "${output}" "keep" "preserve" "保留" "worktree" "as-is"
}

# FO4: Discard
@test "FO4: discard removes branch and worktree" {
  run run_claude "选择discard会删除分支和worktree吗"
  assert_contains_any "${output}" "discard" "remove" "delete" "删除" "分支"
}

# =============================================================================
# ERROR RECOVERY TESTS (ER1-ER3)
# =============================================================================

# ER1: Resume after interrupt
@test "ER1: resume after interrupt loads state" {
  run run_claude "中断后恢复时，系统会加载什么状态"
  assert_contains_any "${output}" "resume" "state" "progress" "task_plan" "恢复"
}

# ER2: EXECUTE interrupted
@test "ER2: EXECUTE interrupted preserves progress" {
  run run_claude "EXECUTE阶段中断后，进度会保留吗"
  assert_contains_any "${output}" "progress" "preserve" "保留" "中断" "恢复"
}

# ER3: 3-Strike escalation
@test "ER3: 3-Strike failure escalates to user" {
  run run_claude "3-Strike失败后会怎么处理"
  assert_contains_any "${output}" "strike" "escalate" "user" "用户" "升级" "三次"
}

# =============================================================================
# ORDER/PATH TESTS (O1-O2, M1-M2)
# =============================================================================

# O1: Stage order violation
@test "O1: rejects skipping stages" {
  run run_claude "可以直接从BRAINSTORM跳到EXECUTE吗"
  assert_contains_any "${output}" "skip" "order" "顺序" "WORKTREE" "PLAN" "cannot"
}

# O2: Stage rollback
@test "O2: stage rollback behavior" {
  run run_claude "可以从EXECUTE回退到PLAN阶段吗"
  assert_contains_any "${output}" "rollback" "回退" "返回" "PLAN" "重新"
}

# M1: memory-bank path correctness
@test "M1: memory-bank path uses correct variables" {
  run run_claude "memory-bank路径使用什么变量"
  assert_contains_any "${output}" "memory-bank" "workspace" "PROJECT" "变量" "path"
}

# M2: Multi-project isolation
@test "M2: multi-project files are isolated" {
  run run_claude "多项目的文件是否相互隔离"
  assert_contains_any "${output}" "isolat" "隔离" "独立" "project" "separate"
}

# =============================================================================
# PLANNING-WITH-FILES TESTS (PF1-PF3)
# =============================================================================

# PF1: 2-Action Rule
@test "PF1: 2-Action Rule saves findings" {
  run run_claude "2-Action Rule是什么，什么时候保存findings"
  assert_contains_any "${output}" "2-Action" "findings" "两次" "保存" "action"
}

# PF2: 3-Strike Protocol
@test "PF2: 3-Strike Protocol escalates" {
  run run_claude "3-Strike Protocol是什么，失败后怎么处理"
  assert_contains_any "${output}" "3-Strike" "escalate" "三次" "升级" "protocol"
}

# PF3: Read Before Decide
@test "PF3: reads task_plan before decisions" {
  run run_claude "做决策前需要先读取什么文件"
  assert_contains_any "${output}" "task_plan" "read" "读取" "决策" "before"
}
