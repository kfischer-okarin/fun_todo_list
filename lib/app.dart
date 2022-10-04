import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'domain/event_repository.dart';
import 'domain/todo_list_service.dart';
import 'pages/todo_list_page.dart';

class App extends StatelessWidget {
  final EventRepository _eventRepository;
  final TodoListService _todoListService;

  const App(
      {super.key,
      required EventRepository eventRepository,
      required TodoListService todoListService})
      : _eventRepository = eventRepository,
        _todoListService = todoListService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider.value(value: _todoListService),
          Provider.value(value: _eventRepository)
        ],
        child: const MaterialApp(
          title: 'Fun To Do List',
          home: TodoListPage(),
        ));
  }
}
