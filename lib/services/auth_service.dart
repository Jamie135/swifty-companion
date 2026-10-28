/// Gets an OAuth2 access token from the 42 API (client_credentials flow)
/// and caches it in memory until it expires.
class AuthService {
  String? _token;
  DateTime? _expiration;

  // Return cached token if still valid, otherwise POST https://api.intra.42.fr/oauth/token and refresh it.
  Future<String> getToken({bool toRefresh = false}) async {
    // Return the cached token if it's still valid and not forced to refresh
    if (!toRefresh && _token != null && _expiration != null && 
        DateTime.now().isBefore(_expiration!.subtract(const Duration(seconds: 30)))) {
      return _token!;
    }
    // Fetch a new token from the 42 API
    final response = await http.post(
      Uri.parse('https://api.intra.42.fr/oauth/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'client_credentials',
        'client_id': dotenv.env['CLIENT_ID']!,
        'client_secret': dotenv.env['CLIENT_SECRET']!,
      },
    );
    if (response.statusCode == 200) throw AuthException('Failed to fetch token: ${response.body}');
    // Parse the JSON response and cache the new token and expiration time
    final json = jsonDecode(response.body);
    _token = json['access_token'];
    _expiration = DateTime.now().add(Duration(seconds: json['expires_in']));
    return _token!;
  }
}
