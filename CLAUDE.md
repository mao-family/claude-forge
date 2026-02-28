# claude-me

Personal AI digital worker / AI clone powered by Claude Code.

## Core Principles

1. **Human Plans, AI Executes** - 人类规划，AI执行
2. **Design Before Code** - 设计先于编码
3. **Repository = Single Source of Truth** - 仓库是唯一真相来源
4. **Test First, Always** - 始终测试优先
5. **Encode Taste into Tooling** - 将品味编码到工具中

## Knowledge Locations

### Global (SessionStart 自动加载)
- Read this file (CLAUDE.md)

### Project Knowledge
When in `workspace/repos/{org}/{project}/`:
→ Read `workspace/memory-bank/{project}/CLAUDE.md`

### Feature Knowledge
When on `feature/{name}` branch:
→ Read `workspace/memory-bank/{project}/features/{name}/*.md`

## Directory Structure

- `skills/` - 工作流指导
- `agents/` - 专用子代理
- `hooks/` - 自动化钩子
- `rules/` - 编码规范
- `references/` - 外部知识文档
- `workspace/` - 项目工作区
  - `memory-bank/{project}/` - 项目知识
    - `research/` - 调研输出
    - `insights/` - 洞察输出
    - `features/` - Feature 知识
  - `repos/` - 项目仓库

## Development

See README.md for setup instructions.
