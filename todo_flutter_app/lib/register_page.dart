import 'dart:convert';
import 'package:flutter/material.dart';
import 'auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

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
    setState(() { _loading = true; _message = ''; });
    try {
      final response = await AuthService.register(
        _username.text.trim(),
        _email.text.trim(),
        _password.text.trim(),
      );

      if (response.statusCode == 201) {
        setState(() => _message = 'Registration successful! Redirecting...');
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        Navigator.pop(context);
      } else {
        setState(() => _message = 'Failed (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      setState(() => _message = 'Error: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
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
            TextField(controller: _username, decoration: const InputDecoration(labelText: 'Username')),
            TextField(controller: _email,    decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 20),
            if (_loading) const CircularProgressIndicator() else ElevatedButton(onPressed: _register, child: const Text('Register')),
            if (_message.isNotEmpty) Padding(
              padding: const EdgeInsets.only(top: 12), child: Text(_message, style: const TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}