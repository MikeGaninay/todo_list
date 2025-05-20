import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const _baseUrl = 'http://10.0.2.2:8000/api';

class AuthService {
  /// Attempts login, returns true on 200, logs response for debugging.
  static Future<bool> login(String username, String password) async {
    final uri = Uri.parse('$_baseUrl/token/');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );
    print('LOGIN: ${response.statusCode} ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access', data['access']);
      await prefs.setString('refresh', data['refresh']);
      return true;
    }
    return false;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access');
    return token != null;
  }

  /// Registers a new user. Navigates back to login on success.
  static Future<bool> register(
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
    print('REGISTER: ${response.statusCode} ${response.body}');

    return response.statusCode == 201;
  }
}