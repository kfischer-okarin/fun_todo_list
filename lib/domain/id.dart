import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

abstract class Id extends Equatable {
  final String value;

  const Id(this.value);

  static String generateValue() => const Uuid().v4();

  @override
  List<Object?> get props => [value];

  @override
  String toString() => "$runtimeType(${value.substring(0, 3)}...)";
}
