import 'package:flutter_test/flutter_test.dart';
import 'package:fun_todo_list/domain/event_repository.dart';
import 'package:fun_todo_list/domain/todo_list_service.dart';
import 'package:fun_todo_list/domain/todo_repository.dart';
import 'package:fun_todo_list/infra/event_sourced_todo_repository.dart';
import 'package:fun_todo_list/infra/in_memory_event_repository.dart';

import 'acceptance_test_dsl.dart';
import 'acceptance_tests.dart';

class _TodoListServiceDriver implements AcceptanceTestDriver {
  final TodoRepository _todoRepository =
      EventSourcedTodoRepository(InMemoryEventRepository());
  late TodoListService _service;

  _TodoListServiceDriver() {
    restartApp();
  }

  @override
  Future<void> addTodo(String title) async {
    _service.addTodo(title);
  }

  @override
  Future<List<String>> listTodos() async {
    return _service.listTodos().map((todo) => todo.title).toList();
  }

  @override
  Future<void> restartApp() async {
    _service = TodoListService(_todoRepository);
  }
}

void main() {
  runAcceptanceTests(
      runTest: (description, acceptanceTest) async {
        test(description, () async {
          final driver = _TodoListServiceDriver();
          final dsl = AcceptanceTestDSL(driver);
          await acceptanceTest(dsl);
        });
      },
      tests: acceptanceTests);
}
