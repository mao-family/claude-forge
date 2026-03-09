# Coding Style Rules

Universal coding principles that apply across all languages.

## Immutability

**ALWAYS create new objects, NEVER mutate existing ones.**

- Prevents side effects and race conditions
- Simplifies debugging and testing
- Supports concurrent operations safely

> **Language note**: This rule may be overridden by language-specific rules where mutation is idiomatic.

## File Size

| Metric | Target | Maximum |
|--------|--------|---------|
| Lines per file | 200-400 | 800 |
| Functions per file | 5-10 | 20 |

Split files when exceeding limits. Organize by feature, not file type.

## Function Length

**Maximum 50 lines per function.**

Functions should:

- Do one thing well
- Have descriptive names indicating purpose
- Accept minimal parameters (≤4)

## Nesting Depth

**Maximum 4 levels of nesting.**

```text
# Bad - too deep
if condition:
    for item in items:
        if check:
            for sub in subitems:
                if another:  # Level 5 - too deep
                    ...

# Good - extract to function
def process_subitems(item):
    for sub in subitems:
        if another:
            ...
```

## Error Handling

**Never silently ignore errors.**

| Context | Requirement |
|---------|-------------|
| UI/UX | User-friendly messages |
| Server | Detailed logging with context |
| APIs | Consistent error response format |

```text
# Bad
try:
    risky_operation()
except:
    pass

# Good
try:
    risky_operation()
except SpecificError as e:
    log.error("Operation failed", error=e, context=context)
    raise UserFriendlyError("Something went wrong")
```

## Input Validation

**Validate at system boundaries. Never trust external data.**

External data includes:

- User input
- API responses
- File content
- Environment variables
- Database results

Use schema-based validation where available.

## Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Variables | Descriptive, role-based | `user_count` not `n` |
| Functions | Verb + noun | `calculate_total` |
| Booleans | Question form | `is_valid`, `has_permission` |
| Constants | SCREAMING_SNAKE_CASE | `MAX_RETRIES` |

## Code Quality Checklist

Before completing any code:

- [ ] Readable with clear naming
- [ ] Functions under 50 lines
- [ ] Files under 800 lines
- [ ] Nesting ≤4 levels
- [ ] Errors handled explicitly
- [ ] Inputs validated at boundaries
- [ ] No hardcoded magic values
- [ ] Immutable patterns used

## Related Documentation

| Document | Content |
|----------|---------|
| [shell/coding-style.md](../shell/coding-style.md) | Shell-specific rules |
| [typescript/coding-style.md](../typescript/coding-style.md) | TypeScript-specific rules |
| [python/coding-style.md](../python/coding-style.md) | Python-specific rules |
| [swift/coding-style.md](../swift/coding-style.md) | Swift-specific rules |
