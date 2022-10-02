import 'package:flutter_test/flutter_test.dart';

import 'package:fun_todo_list/domain/event.dart';
import 'package:fun_todo_list/domain/event_repository.dart';

void testEventRepository(EventRepository Function() buildRepository) {
  group('add', () {
    test('adds event', () {
      final repository = buildRepository();
      final event = TodoAdded(id: const EventId('id'), title: 'Buy milk');

      repository.add(event);

      expect(repository, contains(event));
    });
  });
}
