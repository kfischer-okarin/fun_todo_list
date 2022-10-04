import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:fun_todo_list/infra/time_traveling_clock.dart';

void main() {
  test('time should progress normally', () {
    final clock = TimeTravelingClock();
    final time1 = clock.now;
    const waitedDuration = Duration(milliseconds: 100);

    sleep(waitedDuration);

    final time2 = clock.now;
    expect(time2.difference(time1), greaterThan(waitedDuration));
  });

  test('travelBy', () {
    final clock = TimeTravelingClock();
    final time1 = clock.now;
    const traveledDuration = Duration(days: 1);

    clock.travelBy(traveledDuration);

    final time2 = clock.now;

    expect(time2.difference(time1), greaterThan(traveledDuration));
  });
}
