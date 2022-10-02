import 'package:fun_todo_list/domain/event.dart';
import 'package:fun_todo_list/domain/event_repository.dart';
import 'package:fun_todo_list/domain/todo.dart';
import 'package:fun_todo_list/domain/todo_repository.dart';

class EventSourcedTodoRepository extends TodoRepository {
  final EventRepository _eventRepository;

  EventSourcedTodoRepository(this._eventRepository);

  @override
  Iterable<TodoId> get keys => _todos.keys;

  @override
  Todo? operator [](Object? key) => _todos[key];

  @override
  void add(Todo todo) {
    _eventRepository.add(TodoAdded(
        id: EventId.generate(), todoId: todo.id.value, title: todo.title));
  }

  Map<TodoId, Todo> get _todos {
    Map<TodoId, Todo> result = {};

    for (final event in _eventRepository) {
      if (event is TodoAdded) {
        final id = TodoId(event.todoId);
        result[id] = Todo(id: id, title: event.title);
      }
    }

    return result;
  }
}
