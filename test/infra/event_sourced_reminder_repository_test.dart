import 'package:fun_todo_list/infra/event_sourced_reminder_repository.dart';
import 'package:fun_todo_list/infra/in_memory_event_repository.dart';
import 'package:fun_todo_list/infra/real_clock.dart';

import '../domain/reminder_repository_tests.dart';

void main() {
  EventSourcedReminderRepository buildRepository() =>
      EventSourcedReminderRepository(
          eventRepository: InMemoryEventRepository(), clock: RealClock());

  testReminderRepository(buildRepository);
}
