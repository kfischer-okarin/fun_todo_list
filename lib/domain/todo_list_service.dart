import 'todo.dart';
import 'todo_repository.dart';

class TodoListService {
  final TodoRepository _todoRepository;

  TodoListService(this._todoRepository);

  Todo addTodo(String title) {
    final todo = Todo(id: TodoId.generate(), title: title);
    _todoRepository.add(todo);
    return todo;
  }

  List<Todo> listTodos() => _todoRepository.values.toList();
}
