import 'package:flutter/foundation.dart';
import 'package:fun_todo_list/domain/reminder.dart';

import 'clock.dart';
import 'reminder_repository.dart';
import 'todo.dart';
import 'todo_repository.dart';

class TodoListService {
  final Clock _clock;
  final ReminderRepository _reminderRepository;
  final TodoRepository _todoRepository;

  TodoListService(
      {required Clock clock,
      required TodoRepository todoRepository,
      required ReminderRepository reminderRepository})
      : _clock = clock,
        _reminderRepository = reminderRepository,
        _todoRepository = todoRepository;

  TodoView addTodo(String title) {
    final todo = Todo(id: TodoId.generate(), title: title);
    _todoRepository.add(todo);
    _reminderRepository.add(Reminder(
        id: ReminderId.generate(),
        todoId: todo.id,
        time: _clock.now.add(const Duration(minutes: 1))));
    return _buildTodoView(todo);
  }

  List<TodoView> listTodos() =>
      _todoRepository.values.map((todo) => _buildTodoView(todo)).toList();

  TodoView checkTodo(TodoView todo) {
    final data = _todoRepository[TodoId(todo.id)]!;
    data.check(_clock.now);

    final reminders = _reminderRepository.values.where((reminder) =>
        reminder.todoId == data.id && !reminder.isDue(_clock.now));
    for (final reminder in reminders) {
      _reminderRepository.remove(reminder.id);
    }

    return _buildTodoView(data);
  }

  TodoView uncheckTodo(TodoView todo) {
    final data = _todoRepository[TodoId(todo.id)]!;
    data.uncheck();
    return _buildTodoView(data);
  }

  List<ReminderView> listPendingReminders() => _reminderRepository.values
      .where((reminder) => reminder.isDue(_clock.now))
      .map((reminder) =>
          ReminderView(todoId: reminder.todoId.value, time: reminder.time))
      .toList();

  TodoView _buildTodoView(Todo todo) {
    return TodoView(
        id: todo.id.value,
        title: todo.title,
        checked: todo.checkedAt(_clock.now));
  }
}

@immutable
class TodoView {
  final String id;
  final String title;
  final bool checked;

  const TodoView(
      {required this.id, required this.title, required this.checked});
}

@immutable
class ReminderView {
  final String todoId;
  final DateTime time;

  const ReminderView({required this.todoId, required this.time});
}
