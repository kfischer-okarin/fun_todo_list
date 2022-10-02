import 'package:flutter_test/flutter_test.dart';

import 'package:fun_todo_list/domain/todo_list_service.dart';

void main() {
  setUp(() {
    TodoListService.todos.clear();
  });

  group('addTodo', () {
    test('return added todo', () {
      final service = TodoListService();

      final todo = service.addTodo('Buy milk');

      expect(todo.title, 'Buy milk');
    });
  });

  group('listTodos', () {
    test('return all added todos', () {
      final service = TodoListService();
      service.addTodo('Buy milk');
      service.addTodo('Buy eggs');

      final todos = service.listTodos();

      expect(todos, [
        Todo('Buy milk'),
        Todo('Buy eggs'),
      ]);
    });
  });
}
