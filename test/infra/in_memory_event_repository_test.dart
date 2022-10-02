import 'package:fun_todo_list/infra/in_memory_event_repository.dart';

import '../domain/event_repository_tests.dart';

void main() {
  InMemoryEventRepository buildRepository() => InMemoryEventRepository();

  testEventRepository(buildRepository);
}
