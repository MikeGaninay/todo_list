import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'tasks_page.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final loggedIn = await AuthService.isLoggedIn();
  runApp(TodoApp(startOnTasks: loggedIn));
}

class TodoApp extends StatelessWidget {
  final bool startOnTasks;
  const TodoApp({super.key, required this.startOnTasks});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: startOnTasks ? const TaskPage() : const LoginPage(),
    );
  }
}