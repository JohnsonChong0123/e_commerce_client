import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/auth/login.dart';
import '../../../domain/usecases/auth/sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUp _signUp;
  final Login _login;

  AuthBloc({required SignUp signUp, required Login login})
    : _signUp = signUp,
      _login = login,
      super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
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
    res.fold((l) => emit(AuthFailure(l.message)), (_) => emit(AuthSuccess()));
  }

  
  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _login(
      LoginParams(email: event.email, password: event.password),
    );
    res.fold((l) => emit(AuthFailure(l.message)), (_) => emit(AuthSuccess()));
  }
}
