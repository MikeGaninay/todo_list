import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'tasks_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  String _error = '';
  bool _loading = false;

  Future<void> _login() async {
    setState(() => _loading = true);
    final success = await AuthService.login(
      _username.text,
      _password.text,
    );
    setState(() => _loading = false);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const TaskPage(),
        ),
      );
    } else {
      setState(() {
        _error = 'Login failed: check credentials';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _username,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _password,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (_loading) const CircularProgressIndicator(),
            if (!_loading)
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegisterPage()),
              ),
              child: const Text('Register'),
            ),
            if (_error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(_error, style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}