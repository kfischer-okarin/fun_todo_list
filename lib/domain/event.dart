import 'package:uuid/uuid.dart';

abstract class Event {
  final EventId id;

  const Event({required this.id});

  static Event fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'TodoAdded':
        return TodoAdded.fromJson(json);
      default:
        throw Exception('Unknown event type: ${json['type']}');
    }
  }

  Map<String, dynamic> toJson() => {
        'type': runtimeType.toString(),
        'id': id.value,
      };

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) =>
      other is Event && runtimeType == other.runtimeType && id == other.id;
}

class TodoAdded extends Event {
  final String todoId;
  final String title;

  TodoAdded({required super.id, required this.todoId, required this.title});

  TodoAdded.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        todoId = json['todoId'],
        super(id: EventId(json['id']));

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'todoId': todoId,
        'title': title,
      };

  @override
  String toString() {
    return 'TodoAdded{id: ${id.value}, title: $title}';
  }
}

class EventId {
  final String value;

  const EventId(this.value);

  factory EventId.generate() => EventId(const Uuid().v4());

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) => other is EventId && value == other.value;
}
