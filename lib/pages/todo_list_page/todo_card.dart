import 'package:flutter/material.dart';

import 'package:fun_todo_list/domain/todo.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;
  final Function() onCheck;

  const TodoCard(this.todo, {super.key, required this.onCheck});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
          padding: const EdgeInsets.all(24),
          child: Row(children: [
            Checkbox(
                value: todo.checked,
                onChanged: (_) {
                  if (!todo.checked) {
                    onCheck();
                  }
                }),
            Text(todo.title)
          ])),
    );
  }
}
