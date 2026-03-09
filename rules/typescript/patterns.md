# TypeScript Patterns

> This file extends [common/patterns.md](../common/patterns.md) with TypeScript/JavaScript specific content.

Applies to: `*.ts`, `*.tsx`, `*.js`, `*.jsx`

## API Response Format

**Use consistent response structure:**

```typescript
interface ApiResponse<T> {
  success: boolean;
  data: T | null;
  error: string | null;
  meta?: {
    total: number;
    page: number;
    limit: number;
  };
}

// Success response
const success: ApiResponse<User> = {
  success: true,
  data: user,
  error: null,
};

// Error response
const error: ApiResponse<User> = {
  success: false,
  data: null,
  error: "User not found",
};
```

## Repository Pattern

**Abstract data access:**

```typescript
interface Repository<T, Dto = Partial<T>> {
  findAll(filter?: Partial<T>): Promise<T[]>;
  findById(id: string): Promise<T | null>;
  create(data: Dto): Promise<T>;
  update(id: string, data: Dto): Promise<T>;
  delete(id: string): Promise<void>;
}

class UserRepository implements Repository<User, CreateUserDto> {
  async findAll(filter?: Partial<User>): Promise<User[]> {
    return db.users.findMany({ where: filter });
  }

  async findById(id: string): Promise<User | null> {
    return db.users.findUnique({ where: { id } });
  }

  // ... other methods
}
```

## React Custom Hooks

**Extract reusable logic:**

```typescript
function useDebounce<T>(value: T, delay: number): T {
  const [debouncedValue, setDebouncedValue] = useState(value);

  useEffect(() => {
    const timer = setTimeout(() => setDebouncedValue(value), delay);
    return () => clearTimeout(timer);
  }, [value, delay]);

  return debouncedValue;
}

// Usage
const debouncedSearch = useDebounce(searchTerm, 300);
```

## Error Boundaries

**Handle React errors gracefully:**

```typescript
class ErrorBoundary extends Component<Props, State> {
  state = { hasError: false };

  static getDerivedStateFromError(): State {
    return { hasError: true };
  }

  componentDidCatch(error: Error, info: ErrorInfo): void {
    logger.error("React error", { error, info });
  }

  render(): ReactNode {
    if (this.state.hasError) {
      return <ErrorFallback />;
    }
    return this.props.children;
  }
}
```

## Related Documentation

| Document | Content |
|----------|---------|
| [typescript/coding-style.md](coding-style.md) | TypeScript style rules |
