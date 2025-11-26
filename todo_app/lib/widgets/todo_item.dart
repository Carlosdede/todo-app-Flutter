import 'package:flutter/material.dart';

class TodoItem extends StatelessWidget {
  final Map todo;
  final Function() onToggle;
  final Function() onDelete;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: IconButton(
          icon: Icon(
            todo["done"] ? Icons.check_circle : Icons.circle_outlined,
            color: todo["done"] ? Colors.green : Colors.grey,
          ),
          onPressed: onToggle,
        ),
        title: Text(
          todo["title"],
          style: TextStyle(
            decoration: todo["done"] ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
