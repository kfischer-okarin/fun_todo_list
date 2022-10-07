import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';

import 'package:fun_todo_list/app.dart';
import 'package:fun_todo_list/domain/event_repository.dart';
import 'package:fun_todo_list/domain/todo_list_service.dart';
import 'package:fun_todo_list/infra/event_sourced_todo_repository.dart';
import 'package:fun_todo_list/infra/json_file_event_repository.dart';
import 'package:fun_todo_list/infra/time_traveling_clock.dart';
import 'package:fun_todo_list/pages/todo_list_page.dart';
import 'package:fun_todo_list/pages/todo_list_page/todo_card.dart';

import '../test/acceptance_test_dsl.dart';
import '../test/acceptance_tests.dart';

class _WidgetTesterDriver implements AcceptanceTestDriver {
  final _clock = TimeTravelingClock();
  final WidgetTester tester;
  EventRepository? _eventRepository;
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
  Future<List<Todo>> listTodos() async {
    await _openAppIfNecessary();
    final cards = tester.widgetList<TodoCard>(find.byType(TodoCard));
    return [for (final card in cards) _parseTodoCard(card)];
  }

  @override
  Future<void> restartApp() async {
    await tester.pumpWidget(App(
        eventRepository: _eventRepository!,
        todoListService:
            TodoListService(clock: _clock, todoRepository: _todoRepository!),
        key: UniqueKey()));
  }

  @override
  Future<void> checkTodo(String title) async {
    _assertPage(TodoListPage);

    final checkbox = find.descendant(
        of: find.byWidgetPredicate(
            (widget) => widget is TodoCard && widget.todo.title == title),
        matching: find.byType(Checkbox));

    await tester.tap(checkbox);
    await tester.pumpAndSettle();
  }

  @override
  Future<void> uncheckTodo(String title) async {
    await checkTodo(title);
  }

  @override
  void travelInTimeBy(Duration duration) {
    _clock.travelBy(duration);
  }

  @override
  void travelInTimeTo(DateTime time) {
    _clock.travelTo(time);
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
      _eventRepository = JSONFileEventRepository(jsonFile);
      _todoRepository = EventSourcedTodoRepository(
          eventRepository: _eventRepository!, clock: _clock);
    }

    await restartApp();
  }

  Todo _parseTodoCard(TodoCard card) {
    final cardFinder = find.byWidgetPredicate((widget) => widget == card);
    final title = find
        .descendant(of: cardFinder, matching: find.byType(Text))
        .evaluate()
        .single
        .widget as Text;
    final checkbox = find
        .descendant(of: cardFinder, matching: find.byType(Checkbox))
        .evaluate()
        .single
        .widget as Checkbox;
    return Todo(
      title: title.data!,
      checked: checkbox.value!,
    );
  }

  void _assertPage(Type pageType) {
    if (!find.byType(pageType).precache()) {
      throw StateError('The page $pageType is not open');
    }
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
