import 'package:flutter/material.dart';

import 'package:fun_todo_list/domain/todo_list_service.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;

  const TodoCard(this.todo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child:
          Container(padding: const EdgeInsets.all(24), child: Text(todo.title)),
    );
  }
}
