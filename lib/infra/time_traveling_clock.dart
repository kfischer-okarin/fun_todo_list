import 'package:fun_todo_list/domain/clock.dart';

class TimeTravelingClock extends Clock {
  final DateTime _creationTime = DateTime.now();

  DateTime _originTime = DateTime.now();

  @override
  DateTime get now => _originTime.add(_durationSinceCreation);

  void travelBy(Duration duration) {
    _originTime = _originTime.add(duration);
  }

  Duration get _durationSinceCreation =>
      DateTime.now().difference(_creationTime);
}
