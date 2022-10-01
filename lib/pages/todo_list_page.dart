import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fun_todo_list/domain/todo_list_service.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  TodoListService get _service =>
      Provider.of<TodoListService>(context, listen: false);
  String _title = '';
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
              ListTile(
                title: Text(todo.title),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text('New Todo',
                              style: TextStyle(fontSize: 24)),
                          TextField(
                            autofocus: true,
                            decoration: const InputDecoration(
                              labelText: 'Title',
                            ),
                            onChanged: (value) {
                              setState(() {
                                _title = value;
                              });
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _service.addTodo(_title);
                              Navigator.pop(context);
                              setState(() {
                                _todos = _service.listTodos();
                              });
                            },
                            child: const Text('Add'),
                          )
                        ],
                      ));
                });
          },
          tooltip: 'Add Todo',
          child: const Icon(Icons.add),
        ));
  }
}
