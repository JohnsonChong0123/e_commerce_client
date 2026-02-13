import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../entity/user_entity.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../repositories/auth/auth_repository.dart';

class Login implements UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;
  Login(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return repository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
