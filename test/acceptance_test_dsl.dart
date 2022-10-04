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

  Future<List<Map<String, dynamic>>> listTodos() async =>
      await driver.listTodos();

  Future<void> checkTodo(String title) async {
    await driver.checkTodo(title);
  }

  Future<void> uncheckTodo(String title) async {
    await driver.uncheckTodo(title);
  }

  Future<void> restartApp() async => await driver.restartApp();

  void travelInTimeBy(Duration duration) => driver.travelInTimeBy(duration);
}

abstract class AcceptanceTestDriver {
  Future<void> addTodo(String title);

  Future<List<Map<String, dynamic>>> listTodos();

  Future<void> restartApp();

  Future<void> checkTodo(String title);

  Future<void> uncheckTodo(String title);

  void travelInTimeBy(Duration duration);
}
