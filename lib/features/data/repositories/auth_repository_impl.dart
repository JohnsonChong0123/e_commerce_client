import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/errors/exception.dart';
import '../../domain/repositories/auth/auth_repository.dart';
import '../sources/auth_remote_data.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteData authRemoteData;

  AuthRepositoryImpl(this.authRemoteData);

  @override
  Future<Either<Failure, Unit>> signUpWithEmailPassword({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      await authRemoteData.signUpWithEmailPassword(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        phone: phone,
      );
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
