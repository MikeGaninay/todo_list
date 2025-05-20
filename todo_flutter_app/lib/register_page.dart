// lib/register_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';    // for Response
import 'auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _u = TextEditingController();
  final _e = TextEditingController();
  final _p = TextEditingController();
  bool _loading = false;
  String _msg = '';

  bool get _canSubmit =>
      _u.text.trim().isNotEmpty &&
      _e.text.contains('@') &&
      _p.text.trim().length >= 6;

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _msg = '';
    });

    Response resp;
    try {
      resp = await AuthService.register(
        _u.text.trim(),
        _e.text.trim(),
        _p.text.trim(),
      );
    } catch (e) {
      _msg = 'Network error';
      setState(() => _loading = false);
      return;
    }

    if (resp.statusCode == 201) {
      setState(() => _msg = 'Registration successful! Please log in.');
    } else {
      setState(() => _msg = 'Registration failed (${resp.statusCode})');
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _u,
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'Enter a unique username',
                helperText: 'Required: letters, numbers, no spaces',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _e,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'you@example.com',
                helperText: 'Required: valid email format',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _p,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'At least 6 characters',
                helperText: 'Required: minimum length 6',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _canSubmit ? _submit : null,
                      child: const Text('Register'),
                    ),
                  ),
            if (_msg.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                _msg,
                style: TextStyle(
                  color: _msg.startsWith('Registration successful')
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
