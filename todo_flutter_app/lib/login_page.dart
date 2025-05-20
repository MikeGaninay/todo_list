// lib/login_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';            // for Response
import 'auth_service.dart';
import 'tasks_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _u = TextEditingController();
  final _p = TextEditingController();
  bool _loading = false;

  Future<void> _submit() async {
    final u = _u.text.trim(), p = _p.text.trim();
    if (u.isEmpty || p.isEmpty) {
      _showError('Enter both username and password');
      return;
    }
    setState(() => _loading = true);

    Response resp;
    try {
      resp = await AuthService.login(u, p);
    } catch (e) {
      _showError('Network error');
      setState(() => _loading = false);
      return;
    }

    if (resp.statusCode == 200) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TaskPage()),
      );
    } else {
      _showError('Login failed (${resp.statusCode})');
    }
    setState(() => _loading = false);
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log In')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 60),
            TextField(
              controller: _u,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _p,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 24),
            _loading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Log In'),
                    ),
                  ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegisterPage()),
              ),
              child: const Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
