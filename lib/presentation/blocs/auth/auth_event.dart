part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class AuthSignUp extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;

  const AuthSignUp({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
  });
}

final class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  const AuthLogin({required this.email, required this.password});
}

final class AuthGoogleLogin extends AuthEvent {
  const AuthGoogleLogin();
}

final class AuthFacebookLogin extends AuthEvent {
  const AuthFacebookLogin();
}

final class AuthCheckStatus extends AuthEvent {
  const AuthCheckStatus();
}
