import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';

import 'id.dart';

@immutable
abstract class Event extends Equatable {
  final EventId id;

  const Event({required this.id});

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
      };

  @override
  List<Object?> get props => [id];

  String get propsString => 'id: ${id.value.substring(0, 3)}...';

  @override
  String toString() {
    return '$runtimeType($propsString)';
  }
}

class TodoAdded extends Event {
  final String todoId;
  final String title;

  const TodoAdded(
      {required super.id, required this.todoId, required this.title});

  TodoAdded.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        todoId = json['todoId'],
        super(id: EventId(json['id']));

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'todoId': todoId,
        'title': title,
      };

  @override
  List<Object?> get props => [...super.props, todoId, title];

  @override
  String get propsString =>
      '${super.propsString}, todoId: ${todoId.substring(0, 3)}..., title: $title';
}

class TodoChecked extends Event {
  final String todoId;

  const TodoChecked({required super.id, required this.todoId});

  TodoChecked.fromJson(Map<String, dynamic> json)
      : todoId = json['todoId'],
        super(id: EventId(json['id']));

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

class EventId extends Id {
  const EventId(String value) : super(value);

  factory EventId.generate() => EventId(Id.generateValue());
}
