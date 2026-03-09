# Swift Security

> This file extends [common/security.md](../common/security.md) with Swift specific content.

Applies to: `*.swift`, `Package.swift`

## Secret Management

**Use Keychain for sensitive credentials:**

```swift
// Bad - UserDefaults is not secure
UserDefaults.standard.set(token, forKey: "authToken")

// Good - Use Keychain
import Security

func saveToKeychain(token: String, forKey key: String) throws {
    let data = Data(token.utf8)
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key,
        kSecValueData as String: data
    ]
    SecItemAdd(query as CFDictionary, nil)
}
```

**Use environment variables for build-time secrets:**

```swift
// In .xcconfig (not committed)
API_KEY = your_secret_key

// Access in code
guard let apiKey = ProcessInfo.processInfo.environment["API_KEY"],
      !apiKey.isEmpty else {
    fatalError("API_KEY not configured")
}
```

**Never hardcode secrets** - decompilation exposes them.

## Transport Security

**Keep App Transport Security (ATS) enabled.**

**Implement certificate pinning for sensitive endpoints:**

```swift
class PinnedSessionDelegate: NSObject, URLSessionDelegate {
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        // Validate server certificate
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        // Pin certificate validation...
    }
}
```

## Input Validation

**Sanitize all user input:**

```swift
// Good - validate URL
guard let url = URL(string: userInput),
      ["https", "http"].contains(url.scheme) else {
    throw ValidationError.invalidURL
}

// Good - validate deep links
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
    guard url.scheme == "myapp",
          let host = url.host,
          allowedHosts.contains(host) else {
        return false
    }
    // Process valid deep link
}
```

**Validate external data sources:**

- API responses
- Deep links
- Clipboard content
- File imports

## Related Documentation

| Document | Content |
|----------|---------|
| [common/security.md](../common/security.md) | Universal security principles |
