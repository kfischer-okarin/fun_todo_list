import 'package:uuid/uuid.dart';

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
    return 'Todo{id: ${id.value}, title: $title}';
  }
}

class TodoId {
  final String value;

  const TodoId(this.value);

  factory TodoId.generate() => TodoId(const Uuid().v4());

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) => other is TodoId && value == other.value;
}
