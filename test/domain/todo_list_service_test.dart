import 'package:flutter_test/flutter_test.dart';

import 'package:fun_todo_list/domain/todo_list_service.dart';
import 'package:fun_todo_list/infra/event_sourced_todo_repository.dart';
import 'package:fun_todo_list/infra/in_memory_event_repository.dart';

void main() {
  TodoListService buildService() =>
      TodoListService(EventSourcedTodoRepository(InMemoryEventRepository()));

  group('addTodo', () {
    test('return added todo', () {
      final service = buildService();

      final todo = service.addTodo('Buy milk');

      expect(todo.title, 'Buy milk');
    });
  });

  group('listTodos', () {
    test('return all added todos', () {
      final service = buildService();
      service.addTodo('Buy milk');
      service.addTodo('Buy eggs');

      final todos = service.listTodos();

      final titles = [for (final todo in todos) todo.title];
      expect(titles, ['Buy milk', 'Buy eggs']);
    });
  });

  group('checkTodo', () {
    test('updates the passed todo', () {
      final service = buildService();
      final todo = service.addTodo('Buy milk');

      service.checkTodo(todo);

      expect(todo.checked, true);
    });

    test('updates the persisted todo', () {
      final service = buildService();
      final todo = service.addTodo('Buy milk');

      service.checkTodo(todo);

      final persistedTodo =
          service.listTodos().firstWhere((todo) => todo.id == todo.id);
      expect(persistedTodo.checked, true);
    });
  });
}
