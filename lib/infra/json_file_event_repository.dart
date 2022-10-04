import 'dart:convert';
import 'dart:io';

import 'package:fun_todo_list/domain/event.dart';
import 'package:fun_todo_list/domain/event_repository.dart';

class JSONFileEventRepository extends EventRepository {
  final File _file;
  File get file => _file;
  final List<Event> _events = [];

  JSONFileEventRepository(this._file) {
    if (!_file.existsSync()) {
      _file.writeAsStringSync('[]');
    }
    reload();
  }

  @override
  Iterator<Event> get iterator => _events.iterator;

  @override
  void add(Event event) {
    _events.add(event);
    _file.writeAsStringSync(
        jsonEncode([for (final event in _events) _toJson(event)]));
  }

  void reload() {
    _events.clear();
    _events.addAll([
      for (final json in jsonDecode(_file.readAsStringSync())) _fromJson(json)
    ]);
  }

  Map<String, dynamic> _toJson(Event event) {
    final result = {
      'type': event.runtimeType.toString(),
      'id': event.id.value,
      'time': event.time.toIso8601String(),
    };

    if (event is TodoEvent) {
      result['todoId'] = event.todoId;
    }

    if (event is TodoAdded) {
      result['title'] = event.title;
    }

    return result;
  }

  Event _fromJson(Map<String, dynamic> json) {
    final id = EventId(json['id']);
    final time = DateTime.parse(json['time']);
    switch (json['type']) {
      case 'TodoAdded':
        return TodoAdded(
            id: id, time: time, todoId: json['todoId'], title: json['title']);
      case 'TodoChecked':
        return TodoChecked(id: id, time: time, todoId: json['todoId']);
      case 'TodoUnchecked':
        return TodoUnchecked(id: id, time: time, todoId: json['todoId']);
      default:
        throw Exception('Unknown event type: ${json['type']}');
    }
  }
}
