import 'package:flutter/material.dart';
import '../services/api.dart';
import '../storage/secure_storage.dart';
import '../widgets/todo_item.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List todos = [];
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final data = await Api.getTodos();
    setState(() => todos = data);
  }

  Future<void> _addTodo() async {
    if (controller.text.isEmpty) return;
    await Api.createTodo(controller.text);
    controller.clear();
    _loadTodos();
  }

  Future<void> _logout() async {
    await SecureStorage.deleteToken();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minhas Tarefas"),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          )
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: "Nova tarefa",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: _addTodo,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (_, i) {
                final todo = todos[i];
                return TodoItem(
                  todo: todo,
                  onToggle: () async {
                    await Api.toggleTodo(todo["id"]);
                    _loadTodos();
                  },
                  onDelete: () async {
                    await Api.deleteTodo(todo["id"]);
                    _loadTodos();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
