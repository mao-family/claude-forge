# Python Coding Style

> This file extends [common/coding-style.md](../common/coding-style.md) with Python specific content.

Applies to: `*.py`, `*.pyi`

## Standards

**Follow PEP 8 conventions.**

**Use type annotations on all function signatures:**

```python
def calculate_total(items: list[Item], tax_rate: float = 0.1) -> float:
    subtotal = sum(item.price for item in items)
    return subtotal * (1 + tax_rate)
```

## Immutability

**Use frozen dataclasses:**

```python
from dataclasses import dataclass

@dataclass(frozen=True)
class User:
    id: str
    name: str
    email: str

# Immutable - this raises FrozenInstanceError
user.name = "new name"  # Error!

# Create new instance instead
updated_user = User(id=user.id, name="new name", email=user.email)
```

**Use NamedTuple for simple structures:**

```python
from typing import NamedTuple

class Point(NamedTuple):
    x: float
    y: float

point = Point(1.0, 2.0)
```

## Tools

**Required tools:**

| Tool | Purpose | Command |
|------|---------|---------|
| **black** | Code formatting | `black .` |
| **isort** | Import sorting | `isort .` |
| **ruff** | Linting | `ruff check .` |
| **mypy** | Type checking | `mypy .` |

**Configuration in `pyproject.toml`:**

```toml
[tool.black]
line-length = 88

[tool.isort]
profile = "black"

[tool.ruff]
line-length = 88
select = ["E", "F", "I", "N", "W"]

[tool.mypy]
strict = true
```

## Error Handling

**Use specific exceptions:**

```python
# Bad
try:
    do_something()
except Exception:
    pass

# Good
try:
    do_something()
except ValueError as e:
    logger.error("Invalid value", exc_info=e)
    raise UserError("Invalid input") from e
```

## Related Documentation

| Document | Content |
|----------|---------|
| [common/coding-style.md](../common/coding-style.md) | Universal coding principles |
| [python/patterns.md](patterns.md) | Python design patterns |
