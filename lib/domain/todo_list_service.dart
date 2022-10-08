import 'package:flutter/foundation.dart';

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
    return _buildTodoView(todo);
  }

  List<TodoView> listTodos() =>
      _todoRepository.values.map((todo) => _buildTodoView(todo)).toList();

  TodoView checkTodo(TodoView todo) {
    final data = _todoRepository[TodoId(todo.id)]!;
    data.check(_clock.now);
    return _buildTodoView(data);
  }

  TodoView uncheckTodo(TodoView todo) {
    final data = _todoRepository[TodoId(todo.id)]!;
    data.uncheck();
    return _buildTodoView(data);
  }

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
