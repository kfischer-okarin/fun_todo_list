import 'package:flutter_test/flutter_test.dart';

import 'package:fun_todo_list/domain/reminder.dart';
import 'package:fun_todo_list/domain/reminder_repository.dart';
import 'package:fun_todo_list/domain/todo.dart';

void testReminderRepository(ReminderRepository Function() buildRepository) {
  group('add', () {
    test('adds reminder', () {
      final repository = buildRepository();
      final reminder = Reminder(
          id: ReminderId.generate(),
          todoId: TodoId.generate(),
          time: DateTime.now().add(const Duration(hours: 12)));

      repository.add(reminder);

      expect(repository[reminder.id], reminder);
    });
  });

  group('remove', () {
    test('remove reminder', () {
      final repository = buildRepository();
      final reminder = Reminder(
          id: ReminderId.generate(),
          todoId: TodoId.generate(),
          time: DateTime.now().add(const Duration(hours: 12)));
      repository.add(reminder);

      final removed = repository.remove(reminder.id);

      expect(removed, reminder);
      expect(repository[reminder.id], isNull);
    });

    test('remove non existing reminder', () {
      final repository = buildRepository();
      final removed = repository.remove(ReminderId.generate());

      expect(removed, isNull);
    });
  });

  group('values', () {
    test('returns all added reminders', () {
      final repository = buildRepository();
      final reminder1 = Reminder(
          id: ReminderId.generate(),
          todoId: TodoId.generate(),
          time: DateTime.now().add(const Duration(hours: 12)));
      final reminder2 = Reminder(
          id: ReminderId.generate(),
          todoId: TodoId.generate(),
          time: DateTime.now().add(const Duration(hours: 16)));
      repository.add(reminder1);
      repository.add(reminder2);

      expect(repository.values, containsAll([reminder1, reminder2]));
    });
  });
}
