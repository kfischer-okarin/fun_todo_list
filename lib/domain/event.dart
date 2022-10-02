abstract class Event {
  final EventId id;

  const Event({required this.id});

  Map<String, dynamic> toJson() => {'id': id.value};
}

class TodoAdded extends Event {
  final String title;

  TodoAdded({required super.id, required this.title});

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'title': title,
      };
}

class EventId {
  final String value;

  const EventId(this.value);
}
