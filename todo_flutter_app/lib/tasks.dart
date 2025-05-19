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
  List tasks = [];
  final taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access');
  }

  Future<void> _loadTasks() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/todos/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      setState(() {
        tasks = json.decode(response.body);
      });
    }
  }

  Future<void> _addTask() async {
    final token = await _getToken();
    await http.post(
      Uri.parse('http://10.0.2.2:8000/api/todos/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: json.encode({'title': taskController.text}),
    );
    taskController.clear();
    _loadTasks();
  }

  Future<void> _deleteTask(int id) async {
    final token = await _getToken();
    await http.delete(
      Uri.parse('http://10.0.2.2:8000/api/todos/$id/'),
      headers: {'Authorization': 'Bearer $token'},
    );
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
                Expanded(child: TextField(controller: taskController, decoration: const InputDecoration(labelText: 'New Task'))),
                IconButton(onPressed: _addTask, icon: const Icon(Icons.add)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(tasks[index]['title']),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteTask(tasks[index]['id']),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
