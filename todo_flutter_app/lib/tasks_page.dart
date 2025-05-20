import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List _tasks = [];
  final _controller = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access');
  }

  Future<void> _loadTasks() async {
    setState(() => _loading = true);
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('http://localhost:8000/api/todos/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        _tasks = json.decode(response.body);
      });
    }
    setState(() => _loading = false);
  }

  Future<void> _addTask() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final token = await _getToken();
    final res = await http.post(
      Uri.parse('http://localhost:8000/api/todos/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'title': text}),
    );
    _controller.clear();
    if (res.statusCode == 201 || res.statusCode == 200) {
      _loadTasks();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Add failed: \${res.statusCode}')),
      );
    }
  }

  Future<void> _deleteTask(int id) async {
    final token = await _getToken();
    final res = await http.delete(
      Uri.parse('http://localhost:8000/api/todos/\$id/'),
      headers: {'Authorization': 'Bearer \$token'},
    );
    if (res.statusCode == 204 || res.statusCode == 200) {
      _loadTasks();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delete failed: \${res.statusCode}')),
      );
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access');
    await prefs.remove('refresh');
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [IconButton(icon: const Icon(Icons.logout), onPressed: _logout)],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(labelText: 'New Task'),
                  ),
                ),
                IconButton(onPressed: _addTask, icon: const Icon(Icons.add)),
              ],
            ),
          ),
          if (_loading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadTasks,
                child: ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (_, i) => ListTile(
                    title: Text(_tasks[i]['title']),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteTask(_tasks[i]['id']),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}