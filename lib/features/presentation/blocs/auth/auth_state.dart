part of 'auth_bloc.dart';

enum AuthLoadingType { normal, google, facebook }

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {
  final AuthLoadingType type;

  const AuthLoading({this.type = AuthLoadingType.normal});

  @override
  List<Object> get props => [type];
}

final class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class AuthSuccess extends AuthState {
  const AuthSuccess();

  @override
  List<Object> get props => [];
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();

  @override
  List<Object> get props => [];
}

final class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object> get props => [user];
}
