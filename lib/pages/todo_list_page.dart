import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fun_todo_list/domain/todo.dart';
import 'package:fun_todo_list/domain/todo_list_service.dart';

import 'todo_list_page/todo_card.dart';
import 'todo_list_page/todo_form.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  TodoListService get _service =>
      Provider.of<TodoListService>(context, listen: false);
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _todos = _service.listTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          children: [
            for (final todo in _todos)
              TodoCard(todo, onCheck: () {
                _service.checkTodo(todo);
                reload();
              }, onUncheck: () {
                _service.uncheckTodo(todo);
                reload();
              })
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return TodoForm(onSubmit: (title) {
                    _service.addTodo(title);
                    Navigator.pop(context);
                    reload();
                  });
                });
          },
          tooltip: 'Add Todo',
          child: const Icon(Icons.add),
        ));
  }

  void reload() {
    setState(() {
      _todos = _service.listTodos();
    });
  }
}
