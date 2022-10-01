import 'package:flutter/material.dart';

import 'domain/todo_list_service.dart';
import 'pages/todo_list_page.dart';

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
