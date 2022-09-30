import 'package:flutter_test/flutter_test.dart';

void acceptanceTest(
    String description, Future<void> Function(AcceptanceTestDSL) callback,
    {dynamic pending = false}) {
  testWidgets(description, (tester) async {
    final driver = _WidgetTesterDriver(tester);
    final dsl = AcceptanceTestDSL(driver);

    if (pending) {
      markTestSkipped(pending is String ? pending : 'Test is pending');

      try {
        await callback(dsl);

        fail('Test is pending but actually passed');
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    } else {
      await callback(dsl);
    }
  });
}

class AcceptanceTestDSL {
  final AcceptanceTestDriver driver;

  AcceptanceTestDSL(this.driver);
}

abstract class AcceptanceTestDriver {}

class _WidgetTesterDriver implements AcceptanceTestDriver {
  final WidgetTester tester;

  _WidgetTesterDriver(this.tester);
}
