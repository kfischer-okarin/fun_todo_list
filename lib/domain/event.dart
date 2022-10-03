import 'id.dart';

abstract class Event {
  final EventId id;

  const Event({required this.id});

  static Event fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'TodoAdded':
        return TodoAdded.fromJson(json);
      case 'TodoChecked':
        return TodoChecked.fromJson(json);
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

class TodoChecked extends Event {
  final String todoId;

  TodoChecked({required super.id, required this.todoId});

  TodoChecked.fromJson(Map<String, dynamic> json)
      : todoId = json['todoId'],
        super(id: EventId(json['id']));

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'todoId': todoId,
      };

  @override
  String toString() {
    return 'TodoChecked{id: ${id.value}}';
  }
}

class EventId extends Id {
  const EventId(String value) : super(value);

  factory EventId.generate() => EventId(Id.generateValue());
}
