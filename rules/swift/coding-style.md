# Swift Coding Style

> This file extends [common/coding-style.md](../common/coding-style.md) with Swift specific content.

Applies to: `*.swift`, `Package.swift`

## Tools

**Use SwiftFormat and SwiftLint:**

```bash
swiftformat .
swiftlint lint --strict
```

Alternative: `swift-format` (Xcode 16+)

## Immutability

**Prefer `let` over `var`:**

```swift
// Good - immutable by default
let user = User(name: "John")

// Only use var when mutation is required
var count = 0
count += 1
```

**Prefer `struct` over `class`:**

```swift
// Good - value semantics
struct User {
    let id: String
    let name: String
}

// Use class only for:
// - Reference semantics required
// - Inheritance needed
// - Identity matters
```

## Naming

Follow Apple's API Design Guidelines:

- Clarity at point of use
- Name based on role, not type

```swift
// Bad
let string: String
let userArray: [User]

// Good
let greeting: String
let activeUsers: [User]
```

**Use `static let` for constants:**

```swift
// Good
enum Constants {
    static let maxRetries = 3
    static let timeout: TimeInterval = 30
}
```

## Error Handling

**Use Swift 6 typed throws:**

```swift
enum FileError: Error {
    case notFound(path: String)
    case permissionDenied
    case corrupted
}

func readFile(at path: String) throws(FileError) -> Data {
    guard fileExists(at: path) else {
        throw .notFound(path: path)
    }
    // ...
}

// Pattern matching
do {
    let data = try readFile(at: path)
} catch .notFound(let path) {
    print("File not found: \(path)")
} catch .permissionDenied {
    print("Permission denied")
}
```

## Concurrency

**Enable Swift 6 strict concurrency.**

**Use `Sendable` for cross-boundary data:**

```swift
struct UserData: Sendable {
    let id: String
    let name: String
}
```

**Use actors for shared mutable state:**

```swift
actor Counter {
    private var value = 0

    func increment() {
        value += 1
    }

    func current() -> Int {
        value
    }
}
```

**Prefer structured concurrency:**

```swift
// Good - structured
async let user = fetchUser(id)
async let posts = fetchPosts(userId: id)
let (userData, userPosts) = await (user, posts)

// Avoid - unstructured
Task {
    // ...
}
```

## Related Documentation

| Document | Content |
|----------|---------|
| [common/coding-style.md](../common/coding-style.md) | Universal coding principles |
| [swift/patterns.md](patterns.md) | Swift design patterns |
