# Phase 3 — Authentication & Session

**Goal:** Add a real auth feature: login/register screens, secure token storage, a `SessionBloc` that
gates the app, and logout. Removes the hardcoded `"Bereket"` identity.

**Depends on:** Phase 1 (DI/router), Phase 2 (Dio client + secure storage).
**Risk:** Medium-High. Security-sensitive. Get token storage and refresh right.

---

## Checklist
- [ ] 3.1 New feature module `features/auth/` (data/domain/presentation).
- [ ] 3.2 Secure token store (`core/storage/token_store.dart`).
- [ ] 3.3 `AuthRemoteDataSource` (login, register, me, refresh, logout).
- [ ] 3.4 `AuthRepository` + usecases (`Login`, `Register`, `Logout`, `GetCurrentUser`).
- [ ] 3.5 `SessionBloc` (app-level: unknown → authenticated/unauthenticated).
- [ ] 3.6 `LoginPage` + `RegisterPage`.
- [ ] 3.7 Auth gate in `MyApp` (decides initial screen from `SessionBloc`).
- [ ] 3.8 Hook token into the Dio auth interceptor; handle 401 → force logout.
- [ ] 3.9 Replace hardcoded greeting with the real user.

---

## 3.1 Module layout
```
features/auth/
  data/
    datasources/auth_remote_data_source.dart
    models/auth_token_model.dart
    repository/auth_repository_impl.dart
  domain/
    entity/auth_user_entity.dart
    repository/auth_repository.dart
    usecase/{login,register,logout,get_current_user}.dart
  presentation/
    bloc/session/{session_bloc,session_event,session_state}.dart
    bloc/login/{login_bloc,login_event,login_state}.dart
    page/{login_page,register_page}.dart
```

## 3.2 Token store
See [`templates/token_store.dart`](../templates/token_store.dart). Wraps `flutter_secure_storage`:
`saveTokens`, `readAccess`, `readRefresh`, `clear`. Register as a `get_it` lazy singleton; the Dio auth
interceptor (Phase 2) reads from it.

## 3.3 Auth data source
```dart
abstract class AuthRemoteDataSource {
  Future<AuthTokenModel> login(String email, String password);
  Future<AuthTokenModel> register(RegisterParams params);
  Future<AuthUserModel> me();
  Future<AuthTokenModel> refresh(String refreshToken);
  Future<void> logout();
}
```
Implement with Dio against the Django endpoints (`/login`, `/register`, `/user/info`, `/token/refresh`).

## 3.4 Repository + usecases
`AuthRepository` returns `Either<T, Failure>` (Left = success). On successful `login`/`register`, persist
tokens via `TokenStore`. `logout` clears them. Usecases are thin wrappers (match existing style).

## 3.5 `SessionBloc`
App-level bloc. States: `SessionUnknown` (splash) → `SessionAuthenticated(user)` | `SessionUnauthenticated`.
See [`templates/session_bloc.dart`](../templates/session_bloc.dart).
- On startup: read token; if present, call `me()` → authenticated, else unauthenticated.
- `LoggedIn(user)` / `LoggedOut` events transition state.
- Provide it **above** `MaterialApp` so the whole tree can read it.

## 3.6 Login / Register pages
Use a dedicated `LoginBloc` for form submission (loading/error/success). Validate at the boundary only
(email format, non-empty password). On success, dispatch `SessionBloc.LoggedIn`. Build with the design
tokens. Keep it simple: email, password, submit, link to register, inline error text.

## 3.7 Auth gate
```dart
BlocBuilder<SessionBloc, SessionState>(
  builder: (context, state) {
    if (state is SessionUnknown) return const SplashScreen();
    if (state is SessionAuthenticated) return const HomePage();
    return const LoginPage();
  },
)
```
Put this as `home:` of `MaterialApp`; keep `onGenerateRoute` for the rest.

## 3.8 401 handling
The Dio error interceptor on `UnauthorizedException` should (optionally try refresh once, then) emit a
logout. Simplest reliable approach: expose a callback/stream the `SessionBloc` listens to; on 401 →
`LoggedOut` → user lands on login. Avoid infinite refresh loops (don't retry the refresh call itself).

## 3.9 Remove hardcoded identity
- `WelcomeBackBox` "Bereket" → `context.read<SessionBloc>().state` user's name.
- `ProfilePage` (Phase 4 fully) → current user from session as the default profile.

---

## Definition of Done
- [ ] Fresh install shows Login; successful login lands on Home.
- [ ] Tokens stored in secure storage; survive app restart (stay logged in).
- [ ] Logout clears tokens and returns to Login.
- [ ] Authenticated requests carry `Authorization: Bearer`.
- [ ] A 401 from the server logs the user out cleanly (no crash/loop).
- [ ] No hardcoded usernames remain (`grep -rn "Bereket" lib` is empty in UI).
