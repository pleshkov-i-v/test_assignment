# Test Case -- Flutter Learning App

A Flutter application for language learning with courses, lessons, and interactive exercises (multiple-choice, speech-to-text).

## Architecture

The project follows **Clean Architecture** with feature-based module organization. The `lib/` directory is split into four top-level layers:

```
lib/
├── core/          # Shared infrastructure (DI setup, asset loading)
├── data/          # Repository implementations, DTOs, data sources
├── domain/        # Models, repository interfaces, services, exceptions
└── features/      # Feature modules (splash, login, register, home, lesson)
```

Each feature module is self-contained with its own `presentation/` folder containing `bloc/`, `pages/`, and `widgets/` sub-directories.

### Dependency Flow

```
Presentation (Bloc)
        │
        ▼
  Domain (Service)
        │
        ▼
Domain (Repository interface)
        ▲
        │
Data (Repository implementation)
```

- **Blocs** depend only on domain-layer services.
- **Services** depend on repository *interfaces* defined in the domain layer.
- **Data-layer repositories** implement those interfaces, keeping the domain layer free of framework imports.

Dependency injection is handled by **GetIt**. All registrations live in `lib/core/di/service_locator.dart` and are initialised before `runApp()`.

## State Management

State is managed with **BLoC** (`flutter_bloc`) using the standard event/state pattern.

| Bloc | Responsibility |
|------|---------------|
| `HomeBloc` | Loads courses and tracks lesson completion |
| `LoginBloc` | Login form validation and authentication |
| `RegisterBloc` | Registration form handling |
| `LessonBloc` | Lesson flow and exercise navigation |
| `MultipleChoiceCardBloc` | Individual multiple-choice exercise logic |
| `SpeechToTextCardBloc` | Speech recognition exercise logic |

Blocs receive domain services via constructor injection from GetIt. The UI layer uses `BlocProvider` to scope bloc instances and `BlocBuilder` / `BlocListener` to react to state changes.

## Offline Caching

The app operates entirely offline -- there are no remote API calls. All data is sourced and persisted locally.
User credentials are stored in encrypted form in SecureStorage.
User progresses are stored in SQL-database.

### Course Content (Asset-Bundled)

Course and lesson data is shipped as a JSON asset (`assets/data/sample-json.json`) and loaded at runtime via `rootBundle.loadString()`. This means course content is always available regardless of network state.

### Lesson Progress (sqflite)

User progress is persisted in a local SQLite database (`app.db`) through `LessonProgressRepository`. The `lesson_progress` table stores per-user, per-lesson completion status with a composite primary key `(user_id, lesson_id)`. Writes use `ConflictAlgorithm.replace` for upsert semantics, so saving progress is idempotent.

### Authentication & Session (flutter_secure_storage)

User credentials (hashed with SHA-256 + salt via the `crypto` package) and the current session are stored in `flutter_secure_storage` through `AuthStorage`, which implements both `IAuthStorage` and `IUserSessionRepository`. This keeps sensitive data encrypted at rest using platform-native secure storage.

## Navigation

Routing is handled by **go_router**. A `NavigationService` singleton configures route definitions and redirect guards (unauthenticated users are redirected to login; authenticated users on auth routes are redirected to home).

## Key Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_bloc` | State management (BLoC pattern) |
| `get_it` | Service locator / dependency injection |
| `go_router` | Declarative routing |
| `sqflite` | Local SQLite database for lesson progress |
| `flutter_secure_storage` | Encrypted credential storage |
| `crypto` | Password hashing (SHA-256) |
| `speech_to_text` | Speech recognition for exercises |
| `json_annotation` / `json_serializable` | DTO serialization |
