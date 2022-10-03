import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'domain/todo_list_service.dart';
import 'infra/event_sourced_todo_repository.dart';
import 'infra/json_file_event_repository.dart';
import 'infra/real_clock.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final clock = RealClock();
  final documentsDirectory = await getApplicationDocumentsDirectory();
  final jsonFile = File('${documentsDirectory.path}/todos.json');
  final eventRepository = JSONFileEventRepository(jsonFile);
  final todoRepository = EventSourcedTodoRepository(
      eventRepository: eventRepository, clock: clock);
  runApp(App(TodoListService(todoRepository)));
}
