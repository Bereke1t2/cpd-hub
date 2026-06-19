# Phase 2 — Networking Layer

**Goal:** Replace the stubbed `RemoteDataSource` with a real HTTP implementation backed by `Dio`, with
environment config, typed exceptions, and an auth-token interceptor (token wired in Phase 3).

**Depends on:** Phase 1.
**Risk:** Medium. New external dependency + first real I/O. Keep mock sources in place as a fallback flag.

---

## Checklist
- [ ] 2.1 Add `dio` (and `flutter_secure_storage` for Phase 3 token read).
- [ ] 2.2 Env config via `--dart-define` (`core/config/app_config.dart`).
- [ ] 2.3 Real `UrlConstants` (point at the Django REST base).
- [ ] 2.4 Typed exceptions (`core/error/exceptions.dart`).
- [ ] 2.5 Dio client + interceptors (`core/network/dio_client.dart`).
- [ ] 2.6 Implement `RemoteDataSourceImpl` read endpoints.
- [ ] 2.7 Map exceptions → failures in the repo `catch` blocks.
- [ ] 2.8 Contract test against a real/staging endpoint.

---

## 2.1 Dependencies
```yaml
  dio: ^5.7.0
  flutter_secure_storage: ^9.2.2
```

## 2.2 Environment config
Never hardcode the base URL. Use `--dart-define`. See [`templates/app_config.dart`](../templates/app_config.dart).
Run with:
```bash
flutter run --dart-define=API_BASE_URL=https://staging.cpdhub.example/api
```
Add a `--dart-define-from-file=env/dev.json` option for convenience (document in README, don't commit prod).

## 2.3 URLs
Update `core/url_constants.dart`: derive everything from `AppConfig.apiBaseUrl` rather than the literal
`https://api.example.com`. Keep the path constants. Confirm each path against the backend contract.

## 2.4 Typed exceptions
Create `lib/core/error/exceptions.dart` — see [`templates/exceptions.dart`](../templates/exceptions.dart).
`ServerException`, `UnauthorizedException`, `NotFoundException`, `NetworkException`, `ValidationException`.

## 2.5 Dio client
Create `lib/core/network/dio_client.dart` — see [`templates/dio_client.dart`](../templates/dio_client.dart).
It includes:
- `baseUrl`, JSON headers, sane timeouts.
- **Auth interceptor**: reads token from secure storage, sets `Authorization: Bearer …`.
- **Error interceptor**: maps `DioException` → our typed exceptions (401→`Unauthorized`, etc.).
- Optional `LogInterceptor` in debug only.

Register it in `get_it` (Phase 1 injection):
```dart
getIt.registerLazySingleton<Dio>(() => buildDio());
getIt.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl(getIt<Dio>()));
```

## 2.6 Implement `RemoteDataSourceImpl`
Give it a `Dio` constructor arg and implement the read methods. Pattern:
```dart
class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio _dio;
  RemoteDataSourceImpl(this._dio);

  @override
  Future<List<ProblemModel>> getProblems() async {
    final res = await _dio.get(UrlConstants.getProblemsUrl);
    final data = res.data as List;
    return data.map((e) => ProblemModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<DailyProblemModel> getDailyProblems() async {
    final res = await _dio.get(UrlConstants.getDailyProblemUrl);
    return DailyProblemModel.fromJson(res.data as Map<String, dynamic>);
  }
  // …getContests, getInfo, getProfile, getUserInfo similarly.
}
```
The `fromJson` parsers already tolerate field-name variants (`likes`/`numberOfLikes`, `url`/`problemUrl`) —
verify against the real payload and tighten if needed. Write actions (`likeProblem`, etc.) are Phase 5.

## 2.7 Map exceptions in the repo
Replace bare `catch (e) => ServerFailure(e.toString())` with a mapper so users see clean messages:
```dart
} on UnauthorizedException {
  return right(AuthenticationFailure('Please sign in again.'));
} on NotFoundException {
  return right(NotFoundFailure('Not found.'));
} on NetworkException {
  return right(NetworkFailure('No internet connection.'));
} catch (e) {
  return right(ServerFailure('Something went wrong.'));
}
```
(Remember: `Left = success` in this repo — see Phase 0 §1.)

## 2.8 Contract test
Add a throwaway integration check (or a Postman/curl run) confirming each endpoint's JSON matches the
model parsers. Record the agreed field names in a `docs/api-contract.md` if the backend is still moving.

---

## Definition of Done
- [ ] App can fetch problems/contests/daily/profile/info from a real endpoint when pointed at one.
- [ ] No secrets in the repo; base URL comes from `--dart-define`.
- [ ] 401 surfaces as `AuthenticationFailure`, offline as `NetworkFailure`.
- [ ] Mock sources still selectable via flag (so the app runs with no backend).
