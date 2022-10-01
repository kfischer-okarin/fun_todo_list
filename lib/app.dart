import 'package:flutter/material.dart';

import 'domain/todo_list_service.dart';

class App extends StatelessWidget {
  final TodoListService _service;

  const App(this._service, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fun To Do List',
      home: TodoListPage(_service),
    );
  }
}

class TodoListPage extends StatefulWidget {
  final TodoListService _service;

  const TodoListPage(this._service, {super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  String _title = '';
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _todos = widget._service.listTodos();
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
                              widget._service.addTodo(_title);
                              Navigator.pop(context);
                              _todos = widget._service.listTodos();
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
