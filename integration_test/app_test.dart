import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';

import 'package:fun_todo_list/app.dart';
import 'package:fun_todo_list/main.dart';
import 'package:fun_todo_list/infra/time_traveling_clock.dart';
import 'package:fun_todo_list/pages/todo_list_page.dart';
import 'package:fun_todo_list/pages/todo_list_page/todo_card.dart';

import '../test/acceptance_test_dsl.dart';
import '../test/acceptance_tests.dart';

class _WidgetTesterDriver implements AcceptanceTestDriver {
  final _clock = TimeTravelingClock();
  late File _eventsJsonFile;
  final WidgetTester tester;
  bool _started = false;

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
    await tester.pumpWidget(buildApp(
        clock: _clock, eventsJsonFile: _eventsJsonFile, key: UniqueKey()));
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

    if (!_started) {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      _eventsJsonFile = File('${documentsDirectory.path}/todos.json');
      if (_eventsJsonFile.existsSync()) {
        _eventsJsonFile.deleteSync();
      }
      _started = true;
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
