# Python Security

> This file extends [common/security.md](../common/security.md) with Python specific content.

Applies to: `*.py`, `*.pyi`

## Secret Management

**Use environment variables with validation:**

```python
import os

def require_env(name: str) -> str:
    """Get required environment variable or raise error."""
    value = os.environ.get(name)
    if not value:
        raise EnvironmentError(f"Missing required environment variable: {name}")
    return value

# Usage
api_key = require_env("API_KEY")
db_url = require_env("DATABASE_URL")
```

**Use python-dotenv for local development:**

```python
from dotenv import load_dotenv

load_dotenv()  # Load from .env file
```

## Input Validation

**Use Pydantic for schema validation:**

```python
from pydantic import BaseModel, EmailStr, Field

class UserCreate(BaseModel):
    email: EmailStr
    age: int = Field(ge=0, le=150)
    name: str = Field(min_length=1, max_length=100)

# Raises ValidationError if invalid
user = UserCreate(email="user@example.com", age=25, name="John")
```

## SQL Injection Prevention

**Use parameterized queries:**

```python
# Bad - SQL injection risk
cursor.execute(f"SELECT * FROM users WHERE id = '{user_id}'")

# Good - parameterized
cursor.execute("SELECT * FROM users WHERE id = %s", (user_id,))

# Good - ORM
user = session.query(User).filter(User.id == user_id).first()
```

## Dependency Security

**Run security audits:**

```bash
pip-audit
safety check
```

**Pin dependencies:**

```bash
pip freeze > requirements.txt
```

## Related Documentation

| Document | Content |
|----------|---------|
| [common/security.md](../common/security.md) | Universal security principles |
