import 'event.dart';

abstract class EventRepository extends Iterable<Event> {
  void add(Event event);
}
