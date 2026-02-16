import 'package:e_commerce_client/core/usecase/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/auth/facebook_login.dart';
import '../../../domain/usecases/auth/google_login.dart';
import '../../../domain/usecases/auth/login.dart';
import '../../../domain/usecases/auth/sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUp _signUp;
  final Login _login;
  final GoogleLogin _googleLogin;
  final FacebookLogin _facebookLogin;

  AuthBloc({
    required SignUp signUp,
    required Login login,
    required GoogleLogin googleLogin,
    required FacebookLogin facebookLogin,
  }) : _signUp = signUp,
       _login = login,
       _googleLogin = googleLogin,
       _facebookLogin = facebookLogin,
       super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthGoogleLogin>(_onAuthGoogleLogin);
    on<AuthFacebookLogin>(_onAuthFacebookLogin);
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

  void _onAuthGoogleLogin(
    AuthGoogleLogin event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading(type: AuthLoadingType.google));
    final res = await _googleLogin(NoParams());
    res.fold((l) => emit(AuthFailure(l.message)), (_) => emit(AuthSuccess()));
  }

  void _onAuthFacebookLogin(
    AuthFacebookLogin event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading(type: AuthLoadingType.facebook));
    final res = await _facebookLogin(NoParams());
    res.fold((l) => emit(AuthFailure(l.message)), (_) => emit(AuthSuccess()));
  }
}
