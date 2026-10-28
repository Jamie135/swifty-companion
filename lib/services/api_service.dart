import 'auth_service.dart';

/// Wraps the 42 API endpoints and maps HTTP failures to readable errors.
class ApiService {
  ApiService(this._auth);

  final AuthService _auth;

  // TODO: Future<User> fetchUser(String login) — GET /v2/users/:login.
  // Map 404 -> "user not found", 401 -> refresh token and retry once,
  // network errors -> "no connection".
}

class ApiException implements Exception {
  ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
