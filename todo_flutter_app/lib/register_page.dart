import 'package:flutter/material.dart';
import 'auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  String _message = '';
  bool _loading = false;

  Future<void> _register() async {
    setState(() => _loading = true);
    final success = await AuthService.register(
      _username.text,
      _email.text,
      _password.text,
    );
    setState(() => _loading = false);

    setState(() {
      _message =
          success ? 'Registration successful! Please log in.' : 'Registration failed';
    });

    if (success) {
      // Wait a moment then pop back to login
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _username,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Email'),
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
                onPressed: _register,
                child: const Text('Register'),
              ),
            if (_message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(_message),
              ),
          ],
        ),
      ),
    );
  }
}