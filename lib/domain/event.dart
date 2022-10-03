import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';

import 'id.dart';

@immutable
abstract class Event extends Equatable {
  final EventId id;
  final DateTime time;

  const Event({required this.id, required this.time});

  static Event fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'TodoAdded':
        return TodoAdded.fromJson(json);
      case 'TodoChecked':
        return TodoChecked.fromJson(json);
      default:
        throw Exception('Unknown event type: ${json['type']}');
    }
  }

  Map<String, dynamic> toJson() => {
        'type': runtimeType.toString(),
        'id': id.value,
        'time': time.toIso8601String(),
      };

  @override
  List<Object?> get props => [id];

  String get propsString => 'id: ${id.value.substring(0, 3)}..., time: $time';

  @override
  String toString() {
    return '$runtimeType($propsString)';
  }
}

abstract class TodoEvent extends Event {
  final String todoId;

  const TodoEvent(
      {required super.id, required super.time, required this.todoId});

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'todoId': todoId,
      };

  @override
  List<Object?> get props => [...super.props, todoId];

  @override
  String get propsString =>
      '${super.propsString}, todoId: ${todoId.substring(0, 3)}...';
}

class TodoAdded extends TodoEvent {
  final String title;

  const TodoAdded(
      {required super.id,
      required super.time,
      required super.todoId,
      required this.title});

  TodoAdded.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        super(
            id: EventId(json['id']),
            time: DateTime.parse(json['time']),
            todoId: json['todoId']);

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'title': title,
      };

  @override
  List<Object?> get props => [...super.props, title];

  @override
  String get propsString => '${super.propsString}, title: $title';
}

class TodoChecked extends TodoEvent {
  const TodoChecked(
      {required super.id, required super.time, required super.todoId});

  TodoChecked.fromJson(Map<String, dynamic> json)
      : super(
            id: EventId(json['id']),
            time: DateTime.parse(json['time']),
            todoId: json['todoId']);
}

class EventId extends Id {
  const EventId(String value) : super(value);

  factory EventId.generate() => EventId(Id.generateValue());
}
