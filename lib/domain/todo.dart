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
