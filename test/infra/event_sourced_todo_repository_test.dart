import 'package:flutter_test/flutter_test.dart';

import 'package:fun_todo_list/infra/event_sourced_todo_repository.dart';
import 'package:fun_todo_list/infra/in_memory_event_repository.dart';

import '../domain/todo_repository_tests.dart';

void main() {
  EventSourcedTodoRepository buildRepository() =>
      EventSourcedTodoRepository(InMemoryEventRepository());

  testTodoRepository(buildRepository);
}
