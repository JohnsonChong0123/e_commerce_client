import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/entity/user_entity.dart';
import '../../../core/errors/exception.dart';
import '../../domain/repositories/auth/auth_repository.dart';
import '../sources/local/user_local_data.dart';
import '../sources/remote/auth_remote_data.dart';

/// Implementation of [AuthRepository] for authentication operations.
///
/// This class coordinates remote and local data sources:
/// - Uses [AuthRemoteData] for API calls
/// - Uses [UserLocalData] for local storage
///
/// It also converts exceptions to [Failure] for domain layer consistency.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteData authRemoteData;
  final UserLocalData userLocalData;

  AuthRepositoryImpl({
    required this.authRemoteData,
    required this.userLocalData,
  });

  /// Registers a new user via [AuthRemoteData].
  ///
  /// Returns [Unit] on success or [Failure] on error.
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

  /// Logs in a user via [AuthRemoteData] and saves auth via 
  /// [UserLocalData] info locally.
  ///
  /// Returns [UserEntity] on success or [Failure] on error.
  @override
  Future<Either<Failure, UserEntity>> loginWithEmailPassword({
    required email,
    required password,
  }) async {
    try {
      final auth = await authRemoteData.loginWithEmailPassword(
        email: email,
        password: password,
      );

      await userLocalData.saveAuth(
        accessToken: auth.accessToken,
        refreshToken: auth.refreshToken,
        provider: auth.provider,
      );

      return Right(auth.user.toEntity());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
