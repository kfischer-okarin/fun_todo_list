class TodoListService {
  Todo addTodo(String title) {
    return Todo(title);
  }
}

class Todo {
  final String title;

  Todo(this.title);
}
