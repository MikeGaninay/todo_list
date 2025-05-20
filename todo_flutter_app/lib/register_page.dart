import 'dart:convert';
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

    final response = await AuthService.register(
      _username.text,
      _email.text,
      _password.text,
    );

    setState(() => _loading = false);

    if (response.statusCode == 201) {
      setState(() => _message = 'Registration successful!');
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pop(context);
    } else {
      // Show full JSON error
      setState(() => _message = 'Registration failed: ${response.body}');
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
            if (_loading)
              const CircularProgressIndicator()
            else
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
