import 'package:fun_todo_list/domain/clock.dart';

class FakeClock implements Clock {
  @override
  DateTime now;

  FakeClock(this.now);
}
