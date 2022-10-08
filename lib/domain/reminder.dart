import 'package:equatable/equatable.dart';

import 'id.dart';
import 'todo.dart';

class Reminder extends Equatable {
  final ReminderId id;
  final TodoId todoId;
  final DateTime time;

  const Reminder({required this.id, required this.todoId, required this.time});

  @override
  List<Object?> get props => [id, todoId, time];

  @override
  bool get stringify => true;
}

class ReminderId extends Id {
  const ReminderId(String value) : super(value);

  factory ReminderId.generate() => ReminderId(Id.generateValue());
}
