import 'package:flutter_test/flutter_test.dart';

import 'package:fun_todo_list/domain/todo_list_service.dart';

void main() {
  group('addTodo', () {
    test('return added todo', () {
      final service = TodoListService();

      final todo = service.addTodo('Buy milk');

      expect(todo.title, 'Buy milk');
    });
  });
}
