import 'dart:collection';

import 'reminder.dart';

abstract class ReminderRepository
    extends UnmodifiableMapBase<ReminderId, Reminder> {
  void add(Reminder reminder);
}
