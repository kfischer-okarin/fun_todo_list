import 'id.dart';

class Todo {
  final TodoId id;
  final String title;
  final List<DateTime> checkTimes;

  Todo({required this.id, required this.title, List<DateTime>? checkTimes})
      : checkTimes = checkTimes ?? [];

  bool checkedAt(DateTime time) {
    final checkTimesOnSameDay = checkTimes.where((checkTime) =>
        checkTime.year == time.year &&
        checkTime.month == time.month &&
        checkTime.day == time.day);

    if (checkTimesOnSameDay.isEmpty) {
      return false;
    }

    final lastCheckTime = checkTimesOnSameDay.last;

    return time.isAfter(lastCheckTime);
  }

  void check(DateTime time) {
    checkTimes.add(time);
  }

  void uncheck() {
    if (checkTimes.isNotEmpty) {
      checkTimes.removeLast();
    }
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
