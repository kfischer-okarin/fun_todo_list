import 'package:flutter_test/flutter_test.dart';

import 'package:fun_todo_list/domain/todo.dart';

void main() {
  group('checkedAt', () {
    late Todo todo;

    setUp(() {
      todo = Todo(
        id: TodoId.generate(),
        title: 'Buy Milk',
      );
    });

    test('true if on the same day as check', () {
      todo.check(DateTime(2022, 10, 5, 12, 0, 0));

      expect(todo.checkedAt(DateTime(2022, 10, 5, 13, 0, 0)), true);
    });

    test('false if before the check time on the same day', () {
      todo.check(DateTime(2022, 10, 5, 12, 0, 0));

      expect(todo.checkedAt(DateTime(2022, 10, 5, 11, 0, 0)), false);
    });

    test('false if not checked at all', () {
      expect(todo.checkedAt(DateTime(2022, 10, 5, 11, 0, 0)), false);
    });

    test('false if not checked today', () {
      todo.check(DateTime(2022, 10, 4, 12, 0, 0));

      expect(todo.checkedAt(DateTime(2022, 10, 5, 11, 0, 0)), false);
    });

    test('returns state of any time in the past', () {
      todo.check(DateTime(2022, 10, 3, 12, 0, 0));
      todo.check(DateTime(2022, 10, 5, 14, 0, 0));

      expect(todo.checkedAt(DateTime(2022, 10, 3, 13, 0, 0)), true);
    });
  });
}
