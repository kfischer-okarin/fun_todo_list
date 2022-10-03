import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:fun_todo_list/domain/event.dart';
import 'package:fun_todo_list/infra/json_file_event_repository.dart';

import '../domain/event_repository_tests.dart';

void main() {
  final file = File('${Directory.systemTemp.path}/events.json');

  setUp(() {
    if (file.existsSync()) {
      file.deleteSync();
    }
  });

  JSONFileEventRepository buildRepository() => JSONFileEventRepository(file);

  testEventRepository(buildRepository);

  test('Stores events as JSON and restored them', () {
    var repository = buildRepository();

    final events = [
      TodoAdded(
          id: const EventId('1'),
          time: DateTime(2020, 1, 1),
          todoId: '1',
          title: 'Buy milk'),
      TodoChecked(
          id: const EventId('2'), time: DateTime(2020, 1, 2), todoId: '1'),
      TodoUnchecked(
          id: const EventId('3'), time: DateTime(2020, 1, 3), todoId: '1'),
    ];

    for (final event in events) {
      repository.add(event);
    }

    repository = buildRepository();

    expect(repository.toList(), events);
  });
}
