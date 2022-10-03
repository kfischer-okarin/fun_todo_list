import 'package:fun_todo_list/domain/clock.dart';
import 'package:fun_todo_list/domain/event.dart';
import 'package:fun_todo_list/domain/event_repository.dart';
import 'package:fun_todo_list/domain/todo.dart';
import 'package:fun_todo_list/domain/todo_repository.dart';

class EventSourcedTodoRepository extends TodoRepository {
  final EventRepository _eventRepository;
  final Clock _clock;

  EventSourcedTodoRepository(
      {required EventRepository eventRepository, required Clock clock})
      : _eventRepository = eventRepository,
        _clock = clock;

  @override
  Iterable<TodoId> get keys => _todos.keys;

  @override
  Todo? operator [](Object? key) {
    var todo = _todos[key];

    if (todo != null) {
      todo = _TodoProxy(_eventRepository, _clock, todo);
    }

    return todo;
  }

  @override
  void add(Todo todo) {
    _eventRepository.add(TodoAdded(
        id: EventId.generate(),
        time: _clock.now,
        todoId: todo.id.value,
        title: todo.title));
  }

  Map<TodoId, Todo> get _todos {
    Map<TodoId, Todo> result = {};

    for (final event in _eventRepository) {
      if (event is TodoEvent) {
        final id = TodoId(event.todoId);

        if (event is TodoAdded) {
          result[id] = Todo(id: id, title: event.title);
        } else if (event is TodoChecked) {
          result[id]!.check();
        } else if (event is TodoUnchecked) {
          result[id]!.uncheck();
        }
      }
    }

    return result;
  }
}

class _TodoProxy extends Todo {
  final EventRepository _eventRepository;
  final Clock _clock;

  _TodoProxy(this._eventRepository, this._clock, Todo todo)
      : super(id: todo.id, title: todo.title, checked: todo.checked);

  @override
  void check() {
    super.check();
    _eventRepository.add(TodoChecked(
        id: EventId.generate(), time: _clock.now, todoId: id.value));
  }

  @override
  void uncheck() {
    super.uncheck();
    _eventRepository.add(TodoUnchecked(
        id: EventId.generate(), time: _clock.now, todoId: id.value));
  }
}
