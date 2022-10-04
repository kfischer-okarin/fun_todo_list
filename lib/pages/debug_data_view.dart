import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fun_todo_list/domain/event_repository.dart';
import 'package:fun_todo_list/infra/json_file_event_repository.dart';

class DebugDataView extends StatelessWidget {
  const DebugDataView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final repository =
        Provider.of<EventRepository>(context) as JSONFileEventRepository;
    return Editor(repository);
  }
}

class Editor extends StatefulWidget {
  final JSONFileEventRepository repository;

  const Editor(
    this.repository, {
    super.key,
  });

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  late List<Map<String, dynamic>> _eventData;

  @override
  void initState() {
    super.initState();
    setState(() {
      _eventData = _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Event Data'),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                _saveData(_eventData);
                widget.repository.reload();
                Navigator.pop(context);
              },
            )
          ],
        ),
        body: ListView.builder(
            itemBuilder: (context, index) {
              final eventData = _eventData[index];
              return ListTile(
                title: Text(eventData['type']),
                trailing: Text(eventData['time'].substring(0, 19)),
                subtitle: Text(_details(eventData)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MapEditor(eventData, onSave: (data) {
                              setState(() {
                                _eventData[index] = data;
                              });
                            })),
                  );
                },
              );
            },
            itemCount: _eventData.length));
  }

  List<Map<String, dynamic>> _loadData() {
    return jsonDecode(widget.repository.file.readAsStringSync())
        .map<Map<String, dynamic>>((e) => e as Map<String, dynamic>)
        .toList();
  }

  void _saveData(List<Map<String, dynamic>> data) {
    widget.repository.file.writeAsStringSync(jsonEncode(data));
  }

  String _details(Map<String, dynamic> eventData) {
    final details = <String>[];
    for (final key in eventData.keys) {
      if (key != 'type' && key != 'time' && key != 'id') {
        var value = eventData[key];
        if (key == 'todoId') {
          value = "${value.substring(0, 3)}...";
        }
        details.add('$key: $value');
      }
    }
    return details.join(', ');
  }
}

class MapEditor extends StatefulWidget {
  final Map<String, dynamic> initialValue;
  final Function(Map<String, dynamic>) onSave;

  const MapEditor(this.initialValue, {super.key, required this.onSave});

  @override
  State<MapEditor> createState() => _MapEditorState();
}

class _MapEditorState extends State<MapEditor> {
  late Map<String, dynamic> _currentValue;
  late Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _currentValue = {...widget.initialValue};
    _controllers = _currentValue.map<String, TextEditingController>(
        (key, value) => MapEntry(key, TextEditingController(text: value)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Event Data'),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                widget.onSave(_currentValue);
                Navigator.pop(context);
              },
            )
          ],
        ),
        body: Column(
            children: _currentValue.entries.map((entry) {
          return TextField(
            decoration: InputDecoration(labelText: entry.key),
            controller: _controllers[entry.key],
            onChanged: (value) {
              setState(() {
                _currentValue[entry.key] = value;
              });
            },
          );
        }).toList()));
  }
}
