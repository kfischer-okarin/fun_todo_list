import 'id.dart';

class Todo {
  final TodoId id;
  final String title;

  Todo({required this.id, required this.title});

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) =>
      other is Todo && id == other.id && title == other.title;

  @override
  String toString() {
    return 'Todo{id: ${id.value.substring(0, 3)}..., title: $title}';
  }
}

class TodoId extends Id {
  const TodoId(String value) : super(value);

  factory TodoId.generate() => TodoId(Id.generateValue());
}
