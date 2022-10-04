import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'domain/todo_list_service.dart';
import 'pages/todo_list_page.dart';

class App extends StatelessWidget {
  final TodoListService _todoListService;

  const App({super.key, required TodoListService todoListService})
      : _todoListService = todoListService;

  @override
  Widget build(BuildContext context) {
    return Provider.value(
        value: _todoListService,
        child: const MaterialApp(
          title: 'Fun To Do List',
          home: TodoListPage(),
        ));
  }
}
