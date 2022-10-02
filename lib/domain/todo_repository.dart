import 'dart:collection';
import 'todo.dart';

abstract class TodoRepository extends UnmodifiableMapBase<TodoId, Todo> {
  void add(Todo todo);
}
