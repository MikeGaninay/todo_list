import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

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
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/todos/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print('LOAD_TASKS: ${response.statusCode} ${response.body}');
    if (response.statusCode == 200) {
      setState(() {
        _tasks = json.decode(response.body);
        _loading = false;
      });
    }
  }

  Future<void> _addTask() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final token = await _getToken();
    final res = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/todos/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'title': text}),
    );
    print('ADD_TASK: ${res.statusCode} ${res.body}');
    _controller.clear();
    _loadTasks();
  }

  Future<void> _deleteTask(int id) async {
    final token = await _getToken();
    final res = await http.delete(
      Uri.parse('http://10.0.2.2:8000/api/todos/$id/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    print('DELETE_TASK: ${res.statusCode}');
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Tasks')),
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
            const Expanded(child: Center(child: CircularProgressIndicator())),
          if (!_loading)
            Expanded(
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
        ],
      ),
    );
  }
}