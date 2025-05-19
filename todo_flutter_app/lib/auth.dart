import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const baseUrl = 'http://10.0.2.2:8000/api'; // Android emulator localhost

class AuthService {
  static Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/token/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('access', data['access']);
      await prefs.setString('refresh', data['refresh']);
      return true;
    }
    return false;
  }

  static Future<bool> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'email': email, 'password': password}),
    );

    return response.statusCode == 201;
  }
}
