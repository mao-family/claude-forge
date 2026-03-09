# Swift Testing

> This file extends [common/testing.md](../common/testing.md) with Swift specific content.

Applies to: `*.swift`, `Package.swift`

## Framework

**Use Swift Testing with `@Test` and `#expect`:**

```swift
import Testing

@Test
func userValidation() {
    let user = User(email: "test@example.com", age: 25)
    #expect(user.isValid)
}

@Test
func invalidEmailThrows() {
    #expect(throws: ValidationError.invalidEmail) {
        try User(email: "not-an-email")
    }
}
```

## Test Isolation

**Use `init` and `deinit` for setup/teardown:**

```swift
@Test
struct UserServiceTests {
    let service: UserService
    let mockRepo: MockUserRepository

    init() {
        mockRepo = MockUserRepository()
        service = UserService(repository: mockRepo)
    }

    deinit {
        // Cleanup if needed
    }

    @Test
    func createUserSucceeds() async throws {
        let user = try await service.create(name: "Test")
        #expect(user.name == "Test")
    }
}
```

## Parameterized Tests

**Test multiple inputs:**

```swift
@Test(arguments: [
    ("hello", "HELLO"),
    ("world", "WORLD"),
    ("", ""),
])
func uppercaseWorks(input: String, expected: String) {
    #expect(input.uppercased() == expected)
}
```

## Async Testing

**Test async functions:**

```swift
@Test
func fetchUserSucceeds() async throws {
    let user = try await api.fetchUser(id: "123")
    #expect(user.id == "123")
}
```

## Coverage

**Generate coverage report:**

```bash
swift test --enable-code-coverage
```

## Mocking with Protocols

**Use protocol-based dependency injection:**

```swift
protocol UserRepositoryProtocol {
    func find(by id: String) async throws -> User?
}

class MockUserRepository: UserRepositoryProtocol {
    var userToReturn: User?

    func find(by id: String) async throws -> User? {
        return userToReturn
    }
}
```

## Related Documentation

| Document | Content |
|----------|---------|
| [common/testing.md](../common/testing.md) | Universal testing principles |
| [swift/patterns.md](patterns.md) | Protocol-based DI patterns |
