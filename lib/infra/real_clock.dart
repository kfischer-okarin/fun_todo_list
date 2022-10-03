import 'package:fun_todo_list/domain/clock.dart';

class RealClock implements Clock {
  @override
  DateTime get now => DateTime.now();
}
