import 'package:flutter/material.dart';

import 'domain/todo_list_service.dart';
import 'app.dart';

void main() {
  runApp(App(TodoListService()));
}
