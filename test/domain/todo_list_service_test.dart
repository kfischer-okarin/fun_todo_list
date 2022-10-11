import 'package:flutter_test/flutter_test.dart';

import 'package:fun_todo_list/domain/clock.dart';
import 'package:fun_todo_list/domain/todo_list_service.dart';
import 'package:fun_todo_list/infra/event_sourced_reminder_repository.dart';
import 'package:fun_todo_list/infra/event_sourced_todo_repository.dart';
import 'package:fun_todo_list/infra/in_memory_event_repository.dart';
import 'package:fun_todo_list/infra/real_clock.dart';
import 'package:fun_todo_list/infra/time_traveling_clock.dart';

void main() {
  TodoListService buildService({Clock? clock}) {
    final Clock serviceClock = clock ?? RealClock();
    final eventRepository = InMemoryEventRepository();
    return TodoListService(
        clock: serviceClock,
        reminderRepository: EventSourcedReminderRepository(
            eventRepository: eventRepository, clock: serviceClock),
        todoRepository: EventSourcedTodoRepository(
            eventRepository: eventRepository, clock: serviceClock));
  }

  group('addTodo', () {
    test('return added todo', () {
      final service = buildService();

      final todo = service.addTodo('Buy milk');

      expect(todo.title, 'Buy milk');
    });

    test('schedules a reminder between now and tomorrow', () {
      final clock = TimeTravelingClock();
      final now = DateTime(2022, 10, 11, 11, 30, 0);
      final tomorrow = DateTime(2022, 10, 12, 0, 0, 0);
      clock.travelTo(now);
      final service = buildService(clock: clock);
      final todo = service.addTodo('Buy milk');

      expect(service.listPendingReminders(), isEmpty);

      clock.travelTo(tomorrow);
      final reminders = service.listPendingReminders();
      final reminder = reminders.first;
      expect(reminder.todoId, todo.id);
      expect(reminder.time.isAfter(now), true);
      expect(reminder.time.isBefore(tomorrow), true);
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
    test('returns an updated todo', () {
      final service = buildService();
      final todo = service.addTodo('Buy milk');

      final updated = service.checkTodo(todo);

      expect(updated.checked, true);
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

  group('uncheckTodo', () {
    test('returns an updated todo', () {
      final service = buildService();
      var todo = service.addTodo('Buy milk');
      todo = service.checkTodo(todo);

      final updated = service.uncheckTodo(todo);

      expect(updated.checked, false);
    });

    test('updates the persisted todo', () {
      final service = buildService();
      var todo = service.addTodo('Buy milk');
      todo = service.checkTodo(todo);

      service.uncheckTodo(todo);

      final persistedTodo =
          service.listTodos().firstWhere((todo) => todo.id == todo.id);
      expect(persistedTodo.checked, false);
    });
  });
}
