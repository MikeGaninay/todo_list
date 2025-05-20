// lib/tasks_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import 'login_page.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);
  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List _tasks = [];
  final _c = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    bool ok = await _tryReq(() async {
      final token = await AuthService.getAccessToken();
      final resp = await http.get(
        Uri.parse('http://localhost:8000/api/todos/'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (resp.statusCode == 200) {
        _tasks = json.decode(resp.body);
        return true;
      }
      return false;
    });
    if (!ok) _show('Load failed');
    setState(() => _loading = false);
  }

  Future<void> _add() async {
    final t = _c.text.trim();
    if (t.isEmpty) return;
    bool ok = await _tryReq(() async {
      final token = await AuthService.getAccessToken();
      final resp = await http.post(
        Uri.parse('http://localhost:8000/api/todos/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: json.encode({'title': t}),
      );
      if (resp.statusCode == 201) {
        _c.clear();
        await _load();
        return true;
      }
      return false;
    });
    if (!ok) _show('Add failed');
  }

  Future<void> _del(int id) async {
    bool ok = await _tryReq(() async {
      final token = await AuthService.getAccessToken();
      final resp = await http.delete(
        Uri.parse('http://localhost:8000/api/todos/$id/'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (resp.statusCode == 204) {
        await _load();
        return true;
      }
      return false;
    });
    if (!ok) _show('Delete failed');
  }

  Future<bool> _tryReq(Future<bool> Function() fn) async {
    if (await fn()) return true;
    // try refresh once
    if (await AuthService.refreshToken()) {
      return await fn();
    }
    // if still failing → logout
    await AuthService.logout();
    if (!mounted) return false;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
    return false;
  }

  void _show(String m) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  Future<void> _logout() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [IconButton(onPressed: _logout, icon: const Icon(Icons.logout))],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _c,
                    decoration: const InputDecoration(labelText: 'New Task'),
                  ),
                ),
                IconButton(onPressed: _add, icon: const Icon(Icons.add)),
              ],
            ),
          ),
          if (_loading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: RefreshIndicator(
                onRefresh: _load,
                child: ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (_, i) {
                    final t = _tasks[i];
                    return ListTile(
                      title: Text(t['title']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _del(t['id']),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
