import 'id.dart';

class Todo {
  final TodoId id;
  final String title;
  late bool _checked;
  final List<DateTime> _checkTimes = [];

  Todo({required this.id, required this.title, checked = false}) {
    _checked = checked;
  }

  bool get checked => _checked;

  void check(DateTime time) {
    _checkTimes.add(time);
    _checked = true;
  }

  void uncheck() {
    if (_checkTimes.isNotEmpty) {
      _checkTimes.removeLast();
    }
    _checked = false;
  }

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
