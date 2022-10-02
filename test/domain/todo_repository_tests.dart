import 'package:flutter_test/flutter_test.dart';

import 'package:fun_todo_list/domain/todo.dart';
import 'package:fun_todo_list/domain/todo_repository.dart';

void testTodoRepository(TodoRepository Function() buildRepository) {
  group('add', () {
    test('adds todo', () {
      final repository = buildRepository();
      final todo = Todo(id: TodoId.generate(), title: 'Buy Milk');

      repository.add(todo);

      expect(repository[todo.id], todo);
    });
  });
}
