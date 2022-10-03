import 'dart:convert';
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

  group('add', () {
    test('Stores event as JSON', () {
      final repository = buildRepository();

      repository.add(TodoAdded(
          id: const EventId('id1'),
          time: DateTime(2022, 10, 3, 12, 0, 0),
          todoId: 'abc',
          title: 'Buy milk'));

      expect(
          file.readAsStringSync(),
          jsonEncode([
            {
              "type": "TodoAdded",
              "id": "id1",
              "time": "2022-10-03T12:00:00.000",
              "todoId": "abc",
              "title": "Buy milk"
            }
          ]));
    });
  });

  group('list', () {
    test('Reads existing events from file', () {
      var repository = buildRepository();
      final event = TodoAdded(
          id: const EventId('id1'),
          time: DateTime.now(),
          todoId: 'abc',
          title: 'Buy milk');

      repository.add(event);

      repository = buildRepository();

      expect(repository, containsAllInOrder([event]));
    });
  });
}
