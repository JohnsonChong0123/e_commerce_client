import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, Unit>> signUpWithEmailPassword({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
  });
}
