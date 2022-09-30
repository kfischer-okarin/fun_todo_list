import 'package:flutter_test/flutter_test.dart';

/// Run the defined acceptance tests with the specified driver
void runAcceptanceTests(
    AcceptanceTestDriver driver, void Function(AcceptanceTest) defineTests) {
  void test(String description, AcceptanceTestBody test) {
    testWidgets(description, (tester) async {
      final dsl = AcceptanceTestDSL(driver);

      await test(dsl);
    });
  }

  defineTests(test);
}

typedef AcceptanceTest = void Function(String, AcceptanceTestBody);

typedef AcceptanceTestBody = Future<void> Function(AcceptanceTestDSL dsl);

class AcceptanceTestDSL {
  final AcceptanceTestDriver driver;

  AcceptanceTestDSL(this.driver);
}

abstract class AcceptanceTestDriver {}
