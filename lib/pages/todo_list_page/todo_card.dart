import 'package:flutter/material.dart';

import 'package:fun_todo_list/domain/todo_list_service.dart';

class TodoCard extends StatelessWidget {
  final TodoView todo;
  final Function() onCheck;
  final Function() onUncheck;

  const TodoCard(this.todo,
      {super.key, required this.onCheck, required this.onUncheck});

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
                  if (todo.checked) {
                    onUncheck();
                  } else {
                    onCheck();
                  }
                }),
            Text(todo.title)
          ])),
    );
  }
}
