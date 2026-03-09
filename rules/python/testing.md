# Python Testing

> This file extends [common/testing.md](../common/testing.md) with Python specific content.

Applies to: `*.py`, `*.pyi`

## Framework

**Use pytest as the testing framework.**

```python
import pytest

def test_calculate_total():
    items = [Item(price=10), Item(price=20)]
    assert calculate_total(items) == 30

def test_calculate_total_empty():
    assert calculate_total([]) == 0
```

## Fixtures

**Use fixtures for setup:**

```python
import pytest

@pytest.fixture
def sample_user():
    return User(id="1", name="Test", email="test@example.com")

@pytest.fixture
def db_session():
    session = create_session()
    yield session
    session.rollback()
    session.close()

def test_user_creation(db_session, sample_user):
    db_session.add(sample_user)
    assert db_session.query(User).count() == 1
```

## Parametrized Tests

**Test multiple inputs:**

```python
import pytest

@pytest.mark.parametrize("input,expected", [
    ("hello", "HELLO"),
    ("world", "WORLD"),
    ("", ""),
])
def test_uppercase(input: str, expected: str):
    assert uppercase(input) == expected
```

## Mocking

**Use pytest-mock:**

```python
def test_fetch_user(mocker):
    mock_api = mocker.patch("myapp.api.fetch")
    mock_api.return_value = {"id": "1", "name": "Test"}

    result = get_user("1")

    assert result.name == "Test"
    mock_api.assert_called_once_with("/users/1")
```

## Coverage

**Target 80% coverage:**

```bash
pytest --cov=myapp --cov-report=html
```

## Related Documentation

| Document | Content |
|----------|---------|
| [common/testing.md](../common/testing.md) | Universal testing principles |
