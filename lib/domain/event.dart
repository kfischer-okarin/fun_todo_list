import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';

import 'id.dart';

@immutable
abstract class Event extends Equatable {
  final EventId id;
  final DateTime time;

  const Event({required this.id, required this.time});

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

  @override
  List<Object?> get props => [...super.props, title];

  @override
  String get propsString => '${super.propsString}, title: $title';
}

class TodoChecked extends TodoEvent {
  const TodoChecked(
      {required super.id, required super.time, required super.todoId});
}

class TodoUnchecked extends TodoEvent {
  const TodoUnchecked(
      {required super.id, required super.time, required super.todoId});
}

class ReminderScheduled extends TodoEvent {
  final String reminderId;
  final DateTime reminderTime;

  const ReminderScheduled(
      {required super.id,
      required super.time,
      required super.todoId,
      required this.reminderId,
      required this.reminderTime});

  @override
  List<Object?> get props => [...super.props, reminderId, reminderTime];

  @override
  String get propsString =>
      '${super.propsString}, reminderId: $reminderId, reminderTime: $reminderTime';
}

class EventId extends Id {
  const EventId(String value) : super(value);

  factory EventId.generate() => EventId(Id.generateValue());
}
