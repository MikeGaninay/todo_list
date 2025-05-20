// lib/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _baseUrl = 'http://localhost:8000/api';

  /// Login, save tokens on success, and return the raw HTTP response.
  static Future<http.Response> login(String username, String password) async {
    final uri = Uri.parse('$_baseUrl/token/');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );
    if (resp.statusCode == 200) {
      final body = json.decode(resp.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access', body['access']);
      await prefs.setString('refresh', body['refresh']);
    }
    return resp;
  }

  /// Register a new user; returns raw HTTP response.
  static Future<http.Response> register(
      String username, String email, String password) async {
    final uri = Uri.parse('$_baseUrl/register/');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );
    return resp;
  }

  /// Returns true if an access token is stored.
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access') != null;
  }

  /// Retrieve current access token, or null if none.
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access');
  }

  /// Refresh the access token using the stored refresh token.
  /// Returns true on success.
  static Future<bool> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refresh = prefs.getString('refresh');
    if (refresh == null) return false;

    final uri = Uri.parse('$_baseUrl/token/refresh/');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'refresh': refresh}),
    );
    if (resp.statusCode == 200) {
      final body = json.decode(resp.body);
      await prefs.setString('access', body['access']);
      return true;
    }
    return false;
  }

  /// Clear tokens.
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access');
    await prefs.remove('refresh');
  }
}
