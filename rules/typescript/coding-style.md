# TypeScript Coding Style

> This file extends [common/coding-style.md](../common/coding-style.md) with TypeScript/JavaScript specific content.

Applies to: `*.ts`, `*.tsx`, `*.js`, `*.jsx`

## Immutability

**Use spread operator for object updates:**

```typescript
// Bad - mutation
user.name = newName;

// Good - create new object
const updatedUser = { ...user, name: newName };
```

**Use `const` by default:**

```typescript
// Bad
let items = [];

// Good
const items: Item[] = [];
```

## Error Handling

**Use async/await with try-catch:**

```typescript
// Good
async function fetchUser(id: string): Promise<User> {
  try {
    const response = await api.get(`/users/${id}`);
    return response.data;
  } catch (error) {
    logger.error("Failed to fetch user", { id, error });
    throw new UserFetchError(`Could not fetch user ${id}`);
  }
}
```

## Input Validation

**Use Zod for schema validation:**

```typescript
import { z } from "zod";

const UserSchema = z.object({
  email: z.string().email(),
  age: z.number().int().min(0).max(150),
  name: z.string().min(1).max(100),
});

type User = z.infer<typeof UserSchema>;

function createUser(input: unknown): User {
  return UserSchema.parse(input);
}
```

## Logging

**No `console.log` in production code.**

```typescript
// Bad
console.log("User created:", user);

// Good
logger.info("User created", { userId: user.id });
```

Use proper logging libraries (pino, winston, etc.).

## Type Safety

**Prefer strict types over `any`:**

```typescript
// Bad
function process(data: any): any {
  return data.value;
}

// Good
function process<T extends { value: unknown }>(data: T): T["value"] {
  return data.value;
}
```

**Use `unknown` for truly unknown types:**

```typescript
// Good - forces type narrowing
function handleResponse(data: unknown): string {
  if (typeof data === "string") {
    return data;
  }
  throw new Error("Expected string");
}
```

## Related Documentation

| Document | Content |
|----------|---------|
| [common/coding-style.md](../common/coding-style.md) | Universal coding principles |
| [typescript/patterns.md](patterns.md) | TypeScript design patterns |
