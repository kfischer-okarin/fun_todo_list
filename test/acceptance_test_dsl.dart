import 'package:equatable/equatable.dart';

import 'package:flutter_test/flutter_test.dart';

/// Run the defined acceptance tests with the specified driver
void runAcceptanceTests(
    {required Future<void> Function(String, AcceptanceTestBody) runTest,
    required void Function(AcceptanceTest) tests}) {
  void test(String description, AcceptanceTestBody test) async {
    await runTest(description, test);
  }

  tests(test);
}

typedef AcceptanceTest = void Function(String, AcceptanceTestBody);

typedef AcceptanceTestBody = Future<void> Function(AcceptanceTestDSL dsl);

class AcceptanceTestDSL {
  final AcceptanceTestDriver driver;

  AcceptanceTestDSL(this.driver);

  Future<void> addTodo(String title) async {
    await driver.addTodo(title);
  }

  Future<List<Todo>> listTodos() async => await driver.listTodos();

  Future<void> checkTodo(String title) async {
    await driver.checkTodo(title);
  }

  Future<void> uncheckTodo(String title) async {
    await driver.uncheckTodo(title);
  }

  Future<void> restartApp() async => await driver.restartApp();

  void travelInTimeBy(Duration duration) => driver.travelInTimeBy(duration);

  void travelInTimeTo(DateTime time) => driver.travelInTimeTo(time);
}

abstract class AcceptanceTestDriver {
  Future<void> addTodo(String title);

  Future<List<Todo>> listTodos();

  Future<void> restartApp();

  Future<void> checkTodo(String title);

  Future<void> uncheckTodo(String title);

  void travelInTimeBy(Duration duration);

  void travelInTimeTo(DateTime time);
}

class Todo extends Equatable {
  final String title;
  final bool checked;

  const Todo({
    required this.title,
    required this.checked,
  });

  @override
  List<Object?> get props => [title, checked];

  @override
  bool get stringify => true;
}
