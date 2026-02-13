import 'package:equatable/equatable.dart';
/// Represents errors in the domain layer.
/// Repositories convert data layer exceptions into Failures.
class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}
