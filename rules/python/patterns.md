# Python Patterns

> This file extends [common/patterns.md](../common/patterns.md) with Python specific content.

Applies to: `*.py`, `*.pyi`

## Repository Pattern

**Abstract data access:**

```python
from abc import ABC, abstractmethod
from typing import Generic, TypeVar

T = TypeVar("T")

class Repository(ABC, Generic[T]):
    @abstractmethod
    def find_all(self, **filters) -> list[T]:
        pass

    @abstractmethod
    def find_by_id(self, id: str) -> T | None:
        pass

    @abstractmethod
    def create(self, data: dict) -> T:
        pass

    @abstractmethod
    def update(self, id: str, data: dict) -> T:
        pass

    @abstractmethod
    def delete(self, id: str) -> None:
        pass


class UserRepository(Repository[User]):
    def __init__(self, session: Session):
        self.session = session

    def find_all(self, **filters) -> list[User]:
        query = self.session.query(User)
        for key, value in filters.items():
            query = query.filter(getattr(User, key) == value)
        return query.all()

    # ... other methods
```

## Dependency Injection

**Use constructor injection:**

```python
class UserService:
    def __init__(
        self,
        user_repo: UserRepository,
        email_service: EmailService,
    ):
        self.user_repo = user_repo
        self.email_service = email_service

    def create_user(self, data: UserCreate) -> User:
        user = self.user_repo.create(data.dict())
        self.email_service.send_welcome(user.email)
        return user
```

## Context Managers

**Use for resource management:**

```python
from contextlib import contextmanager

@contextmanager
def db_transaction(session: Session):
    try:
        yield session
        session.commit()
    except Exception:
        session.rollback()
        raise
    finally:
        session.close()

# Usage
with db_transaction(session) as s:
    s.add(user)
```

## Async Patterns

**Use asyncio for concurrent operations:**

```python
import asyncio

async def fetch_all_users(user_ids: list[str]) -> list[User]:
    tasks = [fetch_user(id) for id in user_ids]
    return await asyncio.gather(*tasks)
```

## Related Documentation

| Document | Content |
|----------|---------|
| [python/coding-style.md](coding-style.md) | Python style rules |
