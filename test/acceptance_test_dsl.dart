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

  Future<List<String>> listTodos() async => await driver.listTodos();

  Future<void> restartApp() async => await driver.restartApp();
}

abstract class AcceptanceTestDriver {
  Future<void> addTodo(String title);

  Future<List<String>> listTodos();

  Future<void> restartApp();
}
