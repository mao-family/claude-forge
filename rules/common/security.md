# Security Rules

Mandatory security checks for all code.

## Pre-commit Checklist

Before committing any code:

- [ ] No hardcoded credentials or secrets
- [ ] User inputs validated and sanitized
- [ ] Database queries use parameterized statements
- [ ] HTML output sanitized (prevent XSS)
- [ ] Error responses don't expose internal details
- [ ] Sensitive data not logged
- [ ] Access controls verified

## Secret Management

**NEVER hardcode secrets in source code.**

| Do | Don't |
|----|-------|
| Environment variables | Hardcoded strings |
| Secret managers (1Password, Vault) | Config files in repo |
| `.env` files (gitignored) | Committed credentials |

**Validate secrets at startup:**

```text
# Pseudocode - check required secrets exist
required_secrets = ["API_KEY", "DB_PASSWORD"]
for secret in required_secrets:
    if not env.get(secret):
        fail("Missing required secret: " + secret)
```

## Input Validation

**Validate ALL external input at system boundaries.**

External sources:

- User input (forms, URLs, headers)
- API responses
- File uploads
- Deep links / URL schemes
- Clipboard content
- Database results

Validation rules:

- Type checking
- Length limits
- Format validation (email, URL, etc.)
- Allowlist over denylist

## Error Handling

**Never expose internal details in error messages.**

| Context | Show to User | Log Internally |
|---------|--------------|----------------|
| Input validation | "Invalid email format" | Full validation details |
| Server error | "Something went wrong" | Stack trace, context |
| Auth failure | "Invalid credentials" | Which credential failed |

## Incident Response

If a security vulnerability is discovered:

1. **STOP** - Pause current work immediately
2. **ASSESS** - Determine scope of exposure
3. **CONTAIN** - Disable affected functionality if needed
4. **ROTATE** - Change any potentially compromised secrets
5. **AUDIT** - Search codebase for similar vulnerabilities
6. **FIX** - Implement proper fix with tests
7. **DOCUMENT** - Record incident and remediation

## Dependency Security

- Keep dependencies updated
- Review changelogs for security fixes
- Use lockfiles (package-lock.json, Gemfile.lock, etc.)
- Run security audits (`npm audit`, `pip-audit`, etc.)

## Related Documentation

| Document | Content |
|----------|---------|
| [typescript/security.md](../typescript/security.md) | TypeScript-specific security |
| [python/security.md](../python/security.md) | Python-specific security |
| [swift/security.md](../swift/security.md) | Swift-specific security |
