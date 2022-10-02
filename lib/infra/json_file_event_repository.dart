import 'dart:convert';
import 'dart:io';

import 'package:fun_todo_list/domain/event.dart';
import 'package:fun_todo_list/domain/event_repository.dart';

class JSONFileEventRepository extends EventRepository {
  final File _file;
  final List<Event> _events = [];

  JSONFileEventRepository(this._file) {
    if (!_file.existsSync()) {
      _file.writeAsStringSync('[]');
    }
    _events.addAll([
      for (final json in jsonDecode(_file.readAsStringSync()))
        Event.fromJson(json)
    ]);
  }

  @override
  Iterator<Event> get iterator => _events.iterator;

  @override
  void add(Event event) {
    _events.add(event);
    _file.writeAsStringSync(jsonEncode(_events));
  }
}
