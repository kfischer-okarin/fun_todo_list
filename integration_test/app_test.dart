import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:fun_todo_list/app.dart';
import 'package:fun_todo_list/domain/todo_list_service.dart';
import 'package:fun_todo_list/pages/todo_list_page/todo_card.dart';

import '../test/acceptance_test_dsl.dart';
import '../test/acceptance_tests.dart';

class _WidgetTesterDriver implements AcceptanceTestDriver {
  final WidgetTester tester;

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
  Future<List<String>> listTodos() async {
    await _openAppIfNecessary();
    final cards = tester.widgetList<TodoCard>(find.byType(TodoCard));
    return cards.map((card) => card.todo.title).toList();
  }

  Future<void> _openAppIfNecessary() async {
    if (find.byType(App).precache()) {
      return;
    }

    // Add unique key to app to force rebuild
    await tester.pumpWidget(App(TodoListService(), key: UniqueKey()));
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
