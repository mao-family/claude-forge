# Swift Patterns

> This file extends [common/patterns.md](../common/patterns.md) with Swift specific content.

Applies to: `*.swift`, `Package.swift`

## Protocol-Oriented Design

**Create focused protocols with extension defaults:**

```swift
protocol Repository: Sendable {
    associatedtype Entity: Sendable

    func find(by id: String) async throws -> Entity?
    func save(_ entity: Entity) async throws
}

extension Repository {
    func findOrThrow(by id: String) async throws -> Entity {
        guard let entity = try await find(by: id) else {
            throw RepositoryError.notFound(id: id)
        }
        return entity
    }
}
```

## Value Types

**Prefer structs for data models:**

```swift
struct User: Sendable, Codable {
    let id: String
    let name: String
    let email: String
}
```

**Use enums with associated values for state:**

```swift
enum LoadState<T: Sendable>: Sendable {
    case idle
    case loading
    case loaded(T)
    case failed(Error)
}

// Usage
@MainActor
class ViewModel: ObservableObject {
    @Published var state: LoadState<[User]> = .idle

    func load() async {
        state = .loading
        do {
            let users = try await api.fetchUsers()
            state = .loaded(users)
        } catch {
            state = .failed(error)
        }
    }
}
```

## Actor Pattern

**Use actors for shared mutable state:**

```swift
actor Cache<Key: Hashable & Sendable, Value: Sendable> {
    private var storage: [Key: Value] = [:]

    func get(_ key: Key) -> Value? {
        storage[key]
    }

    func set(_ key: Key, value: Value) {
        storage[key] = value
    }

    func remove(_ key: Key) {
        storage.removeValue(forKey: key)
    }
}

// Usage
let cache = Cache<String, User>()
await cache.set("user1", value: user)
let cached = await cache.get("user1")
```

## Dependency Injection

**Use protocol types with defaults:**

```swift
protocol APIClientProtocol: Sendable {
    func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

class UserService {
    private let api: APIClientProtocol

    init(api: APIClientProtocol = APIClient.shared) {
        self.api = api
    }

    func getUser(id: String) async throws -> User {
        try await api.fetch(.user(id: id))
    }
}

// Test with mock
let mockAPI = MockAPIClient()
let service = UserService(api: mockAPI)
```

## Result Builders

**Use for declarative construction:**

```swift
@resultBuilder
struct ArrayBuilder<Element> {
    static func buildBlock(_ components: Element...) -> [Element] {
        components
    }

    static func buildOptional(_ component: [Element]?) -> [Element] {
        component ?? []
    }
}

func buildMenu(@ArrayBuilder<MenuItem> content: () -> [MenuItem]) -> Menu {
    Menu(items: content())
}
```

## Related Documentation

| Document | Content |
|----------|---------|
| [swift/coding-style.md](coding-style.md) | Swift style rules |
| [swift/testing.md](testing.md) | Protocol-based testing |
