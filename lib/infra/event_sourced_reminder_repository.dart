import 'package:fun_todo_list/domain/clock.dart';
import 'package:fun_todo_list/domain/event.dart';
import 'package:fun_todo_list/domain/event_repository.dart';
import 'package:fun_todo_list/domain/reminder.dart';
import 'package:fun_todo_list/domain/reminder_repository.dart';
import 'package:fun_todo_list/domain/todo.dart';

class EventSourcedReminderRepository extends ReminderRepository {
  final EventRepository _eventRepository;
  final Clock _clock;

  EventSourcedReminderRepository(
      {required EventRepository eventRepository, required Clock clock})
      : _eventRepository = eventRepository,
        _clock = clock;

  @override
  Iterable<ReminderId> get keys => _reminders.keys;

  @override
  Reminder? operator [](Object? key) {
    var reminder = _reminders[key];

    return reminder;
  }

  @override
  void add(Reminder reminder) {
    _eventRepository.add(ReminderScheduled(
        id: EventId.generate(),
        time: _clock.now,
        todoId: reminder.todoId.value,
        reminderId: reminder.id.value,
        reminderTime: reminder.time));
  }

  Map<ReminderId, Reminder> get _reminders {
    Map<ReminderId, Reminder> result = {};

    for (final event in _eventRepository) {
      if (event is ReminderScheduled) {
        final id = ReminderId(event.reminderId);

        result[id] = Reminder(
            id: id, todoId: TodoId(event.todoId), time: event.reminderTime);
      }
    }

    return result;
  }
}
