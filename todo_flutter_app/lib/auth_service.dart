import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const _baseUrl = 'http://10.0.2.2:8000/api';

class AuthService {
  /// Attempts login, returns the full response for handling in UI/logging.
  static Future<http.Response> login(String username, String password) async {
    final uri = Uri.parse('$_baseUrl/token/');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );
    print('LOGIN → ${response.statusCode}: ${response.body}');
    return response;
  }

  /// Checks if an access token is stored.
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access') != null;
  }

  /// Registers a new user, returns full response.
  static Future<http.Response> register(
      String username, String email, String password) async {
    final uri = Uri.parse('$_baseUrl/register/');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );
    print('REGISTER → ${response.statusCode}: ${response.body}');
    return response;
  }
}
