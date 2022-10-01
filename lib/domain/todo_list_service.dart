class TodoListService {
  final _todos = <Todo>[];

  Todo addTodo(String title) {
    final todo = Todo(title);
    _todos.add(todo);
    return todo;
  }

  List<Todo> listTodos() => _todos;
}

class Todo {
  final String title;

  Todo(this.title);

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) => other is Todo && title == other.title;

  @override
  String toString() {
    return 'Todo{title: $title}';
  }
}
