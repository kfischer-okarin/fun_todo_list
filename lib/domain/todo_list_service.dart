import 'todo.dart';

class TodoListService {
  static final todos = <Todo>[];

  Todo addTodo(String title) {
    final todo = Todo(id: TodoId.generate(), title: title);
    todos.add(todo);
    return todo;
  }

  List<Todo> listTodos() => todos;
}
