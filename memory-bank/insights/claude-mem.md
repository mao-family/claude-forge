# Insight: claude-mem

**Date:** 2026-03-04

**Sources:**

- [Research: claude-mem](../research/claude-mem.md)

---

## Summary

Claude-mem is a well-architected Claude Code plugin that demonstrates how persistent memory can be achieved through lifecycle hooks, hybrid search (FTS + vector), and progressive disclosure retrieval. Its 3-layer workflow (search → timeline → details) achieves significant token savings. The architecture is complex (Bun worker, SQLite, Chroma, MCP) but provides a comprehensive solution for cross-session context persistence.

## Key Findings

| # | Finding |
|---|---------|
| 1 | Hook-based observation capture using all 5 Claude Code lifecycle hooks is effective |
| 2 | Progressive disclosure (index → timeline → details) achieves ~10x token savings |
| 3 | Hybrid search combining FTS5 and Chroma vectors provides comprehensive recall |
| 4 | MCP tool exposure (`search`, `timeline`, `get_observations`) enables flexible access |
| 5 | Background worker service enables real-time capture and web UI inspection |
| 6 | Simple `<private>` tag pattern provides user-friendly privacy controls |

## Implications for claude-me

Claude-mem solves a real problem (session context loss) with a comprehensive but complex solution. For claude-me:

- **We don't need memory persistence** - Our skills + CLAUDE.md + memory-bank already provide persistent context
- **Progressive disclosure pattern is valuable** - Worth adopting for any retrieval-heavy features
- **Hook patterns are well-established** - Validates our existing hook architecture
- **Complexity warning** - External dependencies (Bun, Chroma, worker service) add operational burden

## Recommendations

| Priority | Recommendation | Rationale |
|----------|----------------|-----------|
| 🟢 LOW | Consider progressive disclosure for future retrieval features | Token efficiency pattern is proven |
| 🟢 LOW | Note the `<private>` tag pattern for potential privacy features | Simple, user-friendly design |
| ⚪ NONE | Do not adopt claude-mem | Our architecture (skills, memory-bank, CLAUDE.md) already solves context persistence more simply |

## Comparison

| Aspect | claude-mem | claude-me |
|--------|------------|-----------|
| Context persistence | Automatic capture + compression | Manual memory-bank + skills |
| Complexity | High (worker, DBs, hooks) | Low (files in repo) |
| Dependencies | Bun, Chroma, SQLite, uv | None beyond Claude Code |
| Search | Hybrid FTS + vector | File-based (Grep, Read) |
| Privacy | `<private>` tags | .gitignore, settings.local.json |
| License | AGPL-3.0 | N/A (personal project) |
