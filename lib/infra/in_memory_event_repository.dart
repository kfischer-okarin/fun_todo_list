import 'package:fun_todo_list/domain/event.dart';
import 'package:fun_todo_list/domain/event_repository.dart';

class InMemoryEventRepository extends EventRepository {
  final List<Event> _events = [];

  @override
  Iterator<Event> get iterator => _events.iterator;

  @override
  void add(Event event) {
    _events.add(event);
  }
}
