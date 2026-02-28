---
name: writing-claude-md
description: Guide for creating or updating CLAUDE.md files. Use this skill when the user wants to create a new CLAUDE.md, update an existing one, set up a new project's instructions, or asks about what should go in CLAUDE.md. Also use when starting a new project or repository that needs Claude Code configuration.
---

# Writing CLAUDE.md

CLAUDE.md is the instruction file for Claude Code. There are two types:

1. **Global CLAUDE.md** (`~/.claude/CLAUDE.md`) - auto-loaded on every session
2. **Project CLAUDE.md** (`memory-bank/{project}/CLAUDE.md`) - read when working on that project

## File Locations

| Type | Location | When Loaded |
|------|----------|-------------|
| Global | `~/.claude/CLAUDE.md` (symlink to `~/Repos/claude-me/CLAUDE.md`) | Every session |
| Child Project | `workspace/memory-bank/{project}/CLAUDE.md` | When in `workspace/repos/{project}/` |

## When to Create CLAUDE.md

- Starting a new project
- Setting up claude-me for the first time
- Onboarding a new codebase to Claude Code
- Documenting project-specific workflows

## Structure

A good CLAUDE.md should be **concise** and **actionable**. Keep it under 100 lines. Details belong in `rules/`, `memory-bank/`, or `README.md`.

### Required Sections

```markdown
# {project-name}

{One-line description of what this project is.}

## Core Principles

{3-5 guiding principles for how to work on this project.}
{Focus on decision-making, not implementation details.}

## Directory Structure

{Tree view showing key directories and files.}
{Include symlinks if applicable.}

## Commands

{Essential commands for building, testing, running.}
```

### Optional Sections

```markdown
## Knowledge Locations

{Where to find additional context.}
{Point to memory-bank/, features/, etc.}

## Development

{Link to README.md for detailed setup.}
```

## Best Practices

1. **English only** - Keep instructions in English for consistency
2. **Concise** - Every line should earn its place
3. **Actionable** - Tell Claude what to do, not what things are
4. **Hierarchical** - Put details in referenced files, not inline
5. **Maintainable** - Structure should be easy to update

## Anti-patterns

- Long prose explanations (use bullet points)
- Implementation details (put in `rules/` or code comments)
- Duplicating README content (link to it instead)
- Mixing languages (stick to English)
- Overly rigid instructions (explain the "why" instead)

## Examples

### Minimal CLAUDE.md

```markdown
# my-project

A web app for task management.

## Core Principles

1. **User First** - Optimize for user experience
2. **Test Everything** - No PR without tests
3. **Keep It Simple** - Avoid over-engineering

## Commands

\`\`\`bash
bun run dev      # Start dev server
bun run test     # Run tests
bun run build    # Production build
\`\`\`

## Development

See README.md for setup instructions.
```

### Parent Project CLAUDE.md (like claude-me)

```markdown
# claude-me

Personal AI digital worker powered by Claude Code.

## Core Principles

1. **Human Plans, AI Executes** - You plan, I execute
2. **Design Before Code** - Think before you code
3. **Repository = Single Source of Truth** - Everything lives in the repo

## Knowledge Locations

### This Project
- `CLAUDE.md` - Global instructions (auto-loaded)
- `memory-bank/` - Project knowledge

### Child Projects
When in `workspace/repos/{project}/`:
→ Read `workspace/memory-bank/{project}/CLAUDE.md`

## Directory Structure

### Repository
\`\`\`
~/Repos/claude-me/
├── skills/                  # Workflow guides
├── agents/                  # Sub-agents
├── hooks/                   # Automation
├── rules/                   # Coding standards
├── memory-bank/             # Project knowledge
├── workspace/
│   ├── repos/{project}/     # Child projects
│   └── memory-bank/{project}/
└── CLAUDE.md
\`\`\`

### Runtime
\`\`\`
~/.claude/
├── CLAUDE.md → claude-me
├── settings.json → claude-me
├── rules/ → claude-me
├── workspace/ → claude-me
└── memory-bank/ → claude-me
\`\`\`

## Commands

\`\`\`bash
bun run install                              # Setup symlinks
claude plugin marketplace update claude-me   # Update plugin
\`\`\`
```

## Checklist

Before finishing a CLAUDE.md, verify:

- [ ] Project name and description at the top
- [ ] Core principles are decision-focused (not implementation details)
- [ ] Directory structure matches reality
- [ ] Commands are tested and work
- [ ] No duplicate content with README.md
- [ ] Under 100 lines
- [ ] English only
