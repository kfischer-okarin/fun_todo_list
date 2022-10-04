import 'clock.dart';
import 'todo.dart';
import 'todo_repository.dart';

class TodoListService {
  final Clock _clock;
  final TodoRepository _todoRepository;

  TodoListService(
      {required Clock clock, required TodoRepository todoRepository})
      : _clock = clock,
        _todoRepository = todoRepository;

  Todo addTodo(String title) {
    final todo = Todo(id: TodoId.generate(), title: title);
    _todoRepository.add(todo);
    return _todoRepository[todo.id]!;
  }

  List<Todo> listTodos() => _todoRepository.values.toList();

  void checkTodo(Todo todo) {
    todo.check();
  }

  void uncheckTodo(Todo todo) {
    todo.uncheck();
  }
}
