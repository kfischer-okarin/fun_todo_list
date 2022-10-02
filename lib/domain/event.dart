abstract class Event {
  Map<String, dynamic> toJson();
}

class TodoAdded extends Event {
  final EventId id;
  final String title;

  TodoAdded({required this.id, required this.title});

  @override
  Map<String, dynamic> toJson() => {
        'id': id.value,
        'title': title,
      };
}

class EventId {
  final String value;

  const EventId(this.value);
}
