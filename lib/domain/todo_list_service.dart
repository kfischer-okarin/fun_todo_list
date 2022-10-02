import 'todo.dart';

class TodoListService {
  static final todos = <Todo>[];

  Todo addTodo(String title) {
    final todo = Todo(title);
    todos.add(todo);
    return todo;
  }

  List<Todo> listTodos() => todos;
}
