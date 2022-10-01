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
}

abstract class AcceptanceTestDriver {}
