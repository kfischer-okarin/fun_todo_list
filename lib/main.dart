import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'domain/clock.dart';
import 'domain/todo_list_service.dart';
import 'infra/event_sourced_reminder_repository.dart';
import 'infra/event_sourced_todo_repository.dart';
import 'infra/json_file_event_repository.dart';
import 'infra/real_clock.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final documentsDirectory = await getApplicationDocumentsDirectory();
  final eventsJsonFile = File('${documentsDirectory.path}/events.json');

  runApp(buildApp(eventsJsonFile: eventsJsonFile));
}

App buildApp({required File eventsJsonFile, Clock? clock, Key? key}) {
  final serviceClock = clock ?? RealClock();
  final eventRepository = JSONFileEventRepository(eventsJsonFile);
  final reminderRepository = EventSourcedReminderRepository(
      eventRepository: eventRepository, clock: serviceClock);
  final todoRepository = EventSourcedTodoRepository(
      eventRepository: eventRepository, clock: serviceClock);
  return App(
    eventRepository: eventRepository,
    todoListService: TodoListService(
        clock: serviceClock,
        reminderRepository: reminderRepository,
        todoRepository: todoRepository),
    key: key,
  );
}
