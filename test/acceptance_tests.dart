import 'package:flutter_test/flutter_test.dart';
import 'acceptance_test_dsl.dart';

void acceptanceTests(AcceptanceTest test) {
  test('Added todos should be visible in the todo overview', (dsl) async {
    await dsl.addTodo('Buy milk');

    final todos = await dsl.listTodos();
    expect(todos, [const Todo(title: 'Buy milk', checked: false)]);
  });

  test('Todos should be persisted over sessions', (dsl) async {
    await dsl.addTodo('Buy milk');
    await dsl.restartApp();

    final todos = await dsl.listTodos();
    expect(todos, [const Todo(title: 'Buy milk', checked: false)]);
  });

  test('Todos can be checked', (dsl) async {
    await dsl.addTodo('Buy milk');
    await dsl.addTodo('Buy eggs');

    await dsl.checkTodo('Buy eggs');

    final todos = await dsl.listTodos();
    expect(todos, [
      const Todo(title: 'Buy milk', checked: false),
      const Todo(title: 'Buy eggs', checked: true),
    ]);
  });

  test('Todos can be unchecked', (dsl) async {
    await dsl.addTodo('Buy milk');
    await dsl.addTodo('Buy eggs');
    await dsl.checkTodo('Buy milk');

    await dsl.uncheckTodo('Buy milk');

    final todos = await dsl.listTodos();
    expect(todos, [
      const Todo(title: 'Buy milk', checked: false),
      const Todo(title: 'Buy eggs', checked: false),
    ]);
  });

  test('Todos are reset every day', (dsl) async {
    await dsl.addTodo('Buy milk');
    await dsl.checkTodo('Buy milk');

    dsl.travelInTimeBy(const Duration(days: 1));

    await dsl.restartApp();
    final todos = await dsl.listTodos();
    expect(todos, [
      const Todo(title: 'Buy milk', checked: false),
    ]);
  });
}
