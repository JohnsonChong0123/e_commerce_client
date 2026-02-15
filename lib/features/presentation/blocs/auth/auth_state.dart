part of 'auth_bloc.dart';

enum AuthLoadingType { normal, google }

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  final AuthLoadingType type;

  const AuthLoading({this.type = AuthLoadingType.normal});

  @override
  List<Object> get props => [type];
}

final class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);
}

final class AuthSuccess extends AuthState {}
