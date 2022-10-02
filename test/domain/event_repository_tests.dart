import 'package:flutter_test/flutter_test.dart';

import 'package:fun_todo_list/domain/event.dart';
import 'package:fun_todo_list/domain/event_repository.dart';

void testEventRepository(EventRepository Function() buildRepository) {
  group('add', () {
    test('adds event', () {
      final repository = buildRepository();
      final event =
          TodoAdded(id: const EventId('id'), todoId: 'abc', title: 'Buy milk');

      repository.add(event);

      expect(repository, containsAllInOrder([event]));
    });
  });

  group('toList', () {
    test('returns events in addition order', () {
      final repository = buildRepository();
      final event1 =
          TodoAdded(id: const EventId('id'), todoId: 'abc', title: 'Buy milk');
      final event2 = TodoAdded(
          id: const EventId('id2'), todoId: 'abc2', title: 'Buy Eggs');

      repository.add(event1);
      repository.add(event2);

      expect(repository.toList(), [event1, event2]);
    });
  });
}
