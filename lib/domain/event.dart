abstract class Event {
  final EventId id;

  const Event({required this.id});

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
  final String title;

  TodoAdded({required super.id, required this.title});

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
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

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) => other is EventId && value == other.value;
}
