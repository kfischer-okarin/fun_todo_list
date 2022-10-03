import 'package:flutter_test/flutter_test.dart';
import 'acceptance_test_dsl.dart';

void acceptanceTests(AcceptanceTest test) {
  test('Added todos should be visible in the todo overview', (dsl) async {
    await dsl.addTodo('Buy milk');

    final todos = await dsl.listTodos();
    expect(todos, [
      {'title': 'Buy milk', 'checked': false}
    ]);
  });

  test('Todos should be persisted over sessions', (dsl) async {
    await dsl.addTodo('Buy milk');
    await dsl.restartApp();

    final todos = await dsl.listTodos();
    expect(todos, [
      {'title': 'Buy milk', 'checked': false}
    ]);
  });

  test('Todos can be checked', (dsl) async {
    await dsl.addTodo('Buy milk');
    await dsl.addTodo('Buy eggs');

    await dsl.checkTodo('Buy eggs');

    final todos = await dsl.listTodos();
    expect(todos, [
      {'title': 'Buy milk', 'checked': false},
      {'title': 'Buy eggs', 'checked': true}
    ]);
  });
}
