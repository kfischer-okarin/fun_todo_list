import 'package:uuid/uuid.dart';

abstract class Id {
  final String value;

  const Id(this.value);

  static String generateValue() => const Uuid().v4();

  @override
  bool operator ==(Object other) =>
      other is Id && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => Object.hash(runtimeType, value);
}
