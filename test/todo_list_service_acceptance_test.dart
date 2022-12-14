import 'package:flutter_test/flutter_test.dart';

import 'package:fun_todo_list/domain/reminder_repository.dart';
import 'package:fun_todo_list/domain/todo_list_service.dart';
import 'package:fun_todo_list/domain/todo_repository.dart';
import 'package:fun_todo_list/infra/event_sourced_reminder_repository.dart';
import 'package:fun_todo_list/infra/event_sourced_todo_repository.dart';
import 'package:fun_todo_list/infra/in_memory_event_repository.dart';
import 'package:fun_todo_list/infra/time_traveling_clock.dart';

import 'acceptance_test_dsl.dart';
import 'acceptance_tests.dart';

class _TodoListServiceDriver implements AcceptanceTestDriver {
  final _clock = TimeTravelingClock();
  late final ReminderRepository _reminderRepository;
  late final TodoRepository _todoRepository;
  late TodoListService _service;

  _TodoListServiceDriver() {
    final eventRepository = InMemoryEventRepository();
    _reminderRepository = EventSourcedReminderRepository(
        eventRepository: eventRepository, clock: _clock);
    _todoRepository = EventSourcedTodoRepository(
        eventRepository: eventRepository, clock: _clock);
    restartApp();
  }

  @override
  Future<void> addTodo(String title) async {
    _service.addTodo(title);
  }

  @override
  Future<List<Todo>> listTodos() async {
    return [
      for (final todo in _service.listTodos())
        Todo(title: todo.title, checked: todo.checked)
    ];
  }

  @override
  Future<void> restartApp() async {
    _service = TodoListService(
        clock: _clock,
        reminderRepository: _reminderRepository,
        todoRepository: _todoRepository);
  }

  @override
  Future<void> checkTodo(String title) async {
    final todo = _service.listTodos().firstWhere((todo) => todo.title == title);
    _service.checkTodo(todo);
  }

  @override
  Future<void> uncheckTodo(String title) async {
    final todo = _service.listTodos().firstWhere((todo) => todo.title == title);
    _service.uncheckTodo(todo);
  }

  @override
  void travelInTimeBy(Duration duration) {
    _clock.travelBy(duration);
  }

  @override
  void travelInTimeTo(DateTime time) {
    _clock.travelTo(time);
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
