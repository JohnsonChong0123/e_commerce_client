import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/usecase/usecase.dart';
import '../../repositories/auth/auth_repository.dart';

class SignUp implements UseCase<Unit, SignUpParams> {
  final AuthRepository repository;
  SignUp(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SignUpParams params) {
    return repository.signUpWithEmailPassword(
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
      password: params.password,
      phone: params.phone,
    );
  }
}

class SignUpParams extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phone;

  const SignUpParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phone,
  });

  @override
  List<Object> get props => [firstName, lastName, email, password, phone];
}
