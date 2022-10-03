import 'package:flutter_test/flutter_test.dart';

import 'package:fun_todo_list/domain/event.dart';
import 'package:fun_todo_list/domain/event_repository.dart';

void testEventRepository(EventRepository Function() buildRepository) {
  group('add', () {
    test('adds event', () {
      final repository = buildRepository();
      const event =
          TodoAdded(id: EventId('id1'), todoId: 'abc', title: 'Buy milk');

      repository.add(event);

      expect(repository, containsAllInOrder([event]));
    });
  });

  group('toList', () {
    test('returns events in addition order', () {
      final repository = buildRepository();
      const event1 =
          TodoAdded(id: EventId('id1'), todoId: 'abc', title: 'Buy milk');
      const event2 =
          TodoAdded(id: EventId('id2'), todoId: 'abc2', title: 'Buy Eggs');

      repository.add(event1);
      repository.add(event2);

      expect(repository.toList(), [event1, event2]);
    });
  });
}
