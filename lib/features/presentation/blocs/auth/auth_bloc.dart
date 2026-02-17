import 'package:e_commerce_client/core/usecase/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
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
    await _handleAuth(
      emit: emit,
      useCase: () => _signUp(
        SignUpParams(
          email: event.email,
          password: event.password,
          firstName: event.firstName,
          lastName: event.lastName,
          phone: event.phone,
        ),
      ),
    );
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    await _handleAuth(
      emit: emit,
      useCase: () =>
          _login(LoginParams(email: event.email, password: event.password)),
    );
  }

  void _onAuthGoogleLogin(
    AuthGoogleLogin event,
    Emitter<AuthState> emit,
  ) async {
    await _handleAuth(
      emit: emit,
      useCase: () => _googleLogin(NoParams()),
      loadingType: AuthLoadingType.google,
    );
  }

  void _onAuthFacebookLogin(
    AuthFacebookLogin event,
    Emitter<AuthState> emit,
  ) async {
    await _handleAuth(
      emit: emit,
      useCase: () => _facebookLogin(NoParams()),
      loadingType: AuthLoadingType.facebook,
    );
  }

  // Helper method to handle authentication logic
  Future<void> _handleAuth({
    required Emitter<AuthState> emit,
    required Future<Either<Failure, dynamic>> Function() useCase,
    AuthLoadingType loadingType = AuthLoadingType.normal,
  }) async {
    emit(AuthLoading(type: loadingType));
    final res = await useCase();
    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(AuthSuccess()),
    );
  }
}
