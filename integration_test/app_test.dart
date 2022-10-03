import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';

import 'package:fun_todo_list/app.dart';
import 'package:fun_todo_list/domain/todo_list_service.dart';
import 'package:fun_todo_list/infra/event_sourced_todo_repository.dart';
import 'package:fun_todo_list/infra/json_file_event_repository.dart';
import 'package:fun_todo_list/pages/todo_list_page/todo_card.dart';

import '../test/acceptance_test_dsl.dart';
import '../test/acceptance_tests.dart';

class _WidgetTesterDriver implements AcceptanceTestDriver {
  final WidgetTester tester;
  EventSourcedTodoRepository? _todoRepository;

  _WidgetTesterDriver(this.tester);

  @override
  Future<void> addTodo(String title) async {
    await _openAppIfNecessary();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.bySemanticsLabel('Title'), title);
    await tester.tap(find.bySemanticsLabel('Add'));
    await tester.pumpAndSettle();
  }

  @override
  Future<List<Map<String, dynamic>>> listTodos() async {
    await _openAppIfNecessary();
    final cards = tester.widgetList<TodoCard>(find.byType(TodoCard));
    return [
      for (final card in cards) {'title': card.todo.title, 'checked': false}
    ];
  }

  @override
  Future<void> restartApp() async {
    await tester
        .pumpWidget(App(TodoListService(_todoRepository!), key: UniqueKey()));
  }

  Future<void> _openAppIfNecessary() async {
    if (find.byType(App).precache()) {
      return;
    }

    if (_todoRepository == null) {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final jsonFile = File('${documentsDirectory.path}/todos.json');
      if (jsonFile.existsSync()) {
        jsonFile.deleteSync();
      }
      final eventRepository = JSONFileEventRepository(jsonFile);
      _todoRepository = EventSourcedTodoRepository(eventRepository);
    }

    await restartApp();
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  runAcceptanceTests(
      runTest: (description, acceptanceTest) async {
        testWidgets(description, (tester) async {
          final driver = _WidgetTesterDriver(tester);
          final dsl = AcceptanceTestDSL(driver);
          await acceptanceTest(dsl);
        });
      },
      tests: acceptanceTests);
}
