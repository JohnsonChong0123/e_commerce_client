import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/auth/sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUp _signUp;

  AuthBloc({required SignUp signUp}) : _signUp = signUp, super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _signUp(
      SignUpParams(
        email: event.email,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
        phone: event.phone,
      ),
    );
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (_) => emit(
        const AuthSuccess(
          "Successfully signed up! Please enter your email and password to login.",
        ),
      ),
    );
  }
}
