import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import 'auth_service.dart';

/// Wraps the 42 API endpoints and maps HTTP failures to readable errors.
class ApiService {
  ApiService(this._auth);

  final AuthService _auth;

  Future<User> fetchUser(String login) async {
    final loginNormalized = login.trim().toLowerCase();
    if (loginNormalized.isEmpty) {
      throw const InvalidLoginException();
    }
    final uri = Uri.https('api.intra.42.fr', '/v2/users/$loginNormalized');

    try {
      var res = await _get(uri);
      // If the token is expired, refresh it and retry the request
      if (res.statusCode == 401) {
        res = await _get(uri, refresh: true);
      }
      switch (res.statusCode) {
        case 200:
          break;
        case 401:
          throw const UnauthorizedException();
        case 404:
          throw UserNotFoundException(loginNormalized);
        case 429:
          throw const RateLimitException();
        case >= 500:
          throw ServerException(res.statusCode);
        default:
          throw ServerException(res.statusCode);
      }
      try {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        return User.fromJson(json);
      } on FormatException {
        throw const ParseException();
      } on TypeError {
        throw const ParseException();
      }
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const RequestTimeoutException();
    } on http.ClientException {
      throw const NetworkException();
    } on AuthException {
      throw const UnauthorizedException();
    }
  }

  /// Headers for cdn.intra.42.fr, which answers 403 without the API token.
  Future<Map<String, String>> imageHeaders() async {
    final token = await _auth.getToken();
    return {'Authorization': 'Bearer $token'};
  }

  Future<http.Response> _get(Uri uri, {bool refresh = false}) async {
    final token = await _auth.getToken(toRefresh: refresh);
    return http
            .get(uri, headers: {'Authorization': 'Bearer $token'})
            .timeout(const Duration(seconds: 10));
  }
}

/// "sealed" is an abstract class that allows only subclasses to extend it.
/// It is used here to define a base class for error handling.
sealed class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class InvalidLoginException  extends ApiException { const InvalidLoginException()  : super('Please enter a login.'); }
class UserNotFoundException  extends ApiException { const UserNotFoundException(String l) : super('User "$l" not found.'); }
class UnauthorizedException  extends ApiException { const UnauthorizedException()  : super('Authentication failed.'); }
class RateLimitException     extends ApiException { const RateLimitException()     : super('Too many requests, try again shortly.'); }
class ServerException        extends ApiException { const ServerException(int c)   : super('42 server error ($c).'); }
class NetworkException       extends ApiException { const NetworkException()       : super('No internet connection.'); }
class RequestTimeoutException extends ApiException { const RequestTimeoutException() : super('Request timed out.'); }
class ParseException         extends ApiException { const ParseException()         : super('Unexpected response from server.'); }
