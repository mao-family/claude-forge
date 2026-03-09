# TypeScript Testing

> This file extends [common/testing.md](../common/testing.md) with TypeScript/JavaScript specific content.

Applies to: `*.ts`, `*.tsx`, `*.js`, `*.jsx`

## Framework

**Use Playwright for E2E testing of critical user flows.**

```typescript
import { test, expect } from "@playwright/test";

test("user can login", async ({ page }) => {
  await page.goto("/login");
  await page.fill('[name="email"]', "user@example.com");
  await page.fill('[name="password"]', "password");
  await page.click('button[type="submit"]');

  await expect(page).toHaveURL("/dashboard");
});
```

## Unit Testing

**Use Vitest or Jest:**

```typescript
import { describe, it, expect } from "vitest";

describe("calculateTotal", () => {
  it("sums items correctly", () => {
    const items = [{ price: 10 }, { price: 20 }];
    expect(calculateTotal(items)).toBe(30);
  });

  it("returns 0 for empty array", () => {
    expect(calculateTotal([])).toBe(0);
  });
});
```

## Mocking

**Mock external dependencies:**

```typescript
import { vi } from "vitest";

vi.mock("./api", () => ({
  fetchUser: vi.fn().mockResolvedValue({ id: "1", name: "Test" }),
}));
```

## Coverage

**Target 80% coverage:**

```bash
vitest --coverage
```

## Related Documentation

| Document | Content |
|----------|---------|
| [common/testing.md](../common/testing.md) | Universal testing principles |
