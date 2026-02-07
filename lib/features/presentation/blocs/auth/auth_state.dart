part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);
}

final class AuthSuccess extends AuthState {
  final String message;

  const AuthSuccess(this.message);
}
