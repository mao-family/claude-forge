# TypeScript Security

> This file extends [common/security.md](../common/security.md) with TypeScript/JavaScript specific content.

Applies to: `*.ts`, `*.tsx`, `*.js`, `*.jsx`

## Secret Management

**Use environment variables with validation:**

```typescript
// Good - validate at startup
const apiKey = process.env.API_KEY;
if (!apiKey) {
  throw new Error("API_KEY environment variable is required");
}

// Better - centralized config
const config = {
  apiKey: requireEnv("API_KEY"),
  dbUrl: requireEnv("DATABASE_URL"),
  port: parseInt(process.env.PORT || "3000", 10),
};

function requireEnv(name: string): string {
  const value = process.env[name];
  if (!value) {
    throw new Error(`Missing required environment variable: ${name}`);
  }
  return value;
}
```

## Input Sanitization

**Sanitize HTML output to prevent XSS:**

```typescript
import DOMPurify from "dompurify";

// Good - sanitize before rendering
const safeHtml = DOMPurify.sanitize(userInput);
```

**Use parameterized queries:**

```typescript
// Bad - SQL injection risk
const query = `SELECT * FROM users WHERE id = '${userId}'`;

// Good - parameterized
const result = await db.query("SELECT * FROM users WHERE id = $1", [userId]);
```

## Dependency Security

**Run security audits:**

```bash
npm audit
npm audit fix
```

**Keep dependencies updated:**

```bash
npm outdated
npm update
```

## Related Documentation

| Document | Content |
|----------|---------|
| [common/security.md](../common/security.md) | Universal security principles |
