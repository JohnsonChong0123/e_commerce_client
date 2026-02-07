import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../errors/failure.dart';

abstract interface class UseCase<ReturnType, Params> {
  Future<Either<Failure, ReturnType>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}