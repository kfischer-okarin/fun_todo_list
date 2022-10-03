import 'todo.dart';
import 'todo_repository.dart';

class TodoListService {
  final TodoRepository _todoRepository;

  TodoListService(this._todoRepository);

  Todo addTodo(String title) {
    final todo = Todo(id: TodoId.generate(), title: title);
    _todoRepository.add(todo);
    return _todoRepository[todo.id]!;
  }

  List<Todo> listTodos() => _todoRepository.values.toList();

  void checkTodo(Todo todo) {
    todo.check();
  }
}
