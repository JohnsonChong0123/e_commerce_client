import 'package:fpdart/fpdart.dart';
import '../../entity/user_entity.dart';
import '../../../../core/errors/failure.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, Unit>> signUpWithEmailPassword({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
  });

  Future<Either<Failure, UserEntity>> loginWithEmailPassword({
    required String email,
    required String password,
  });
}
