import 'package:bloc_test/bloc_test.dart';
import 'package:e_commerce_client/features/domain/entity/user_entity.dart';
import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/core/usecase/usecase.dart';
import 'package:e_commerce_client/features/domain/usecases/auth/check_auth_status.dart';
import 'package:e_commerce_client/features/domain/usecases/auth/facebook_login.dart';
import 'package:e_commerce_client/features/domain/usecases/auth/google_login.dart';
import 'package:e_commerce_client/features/domain/usecases/auth/login.dart';
import 'package:e_commerce_client/features/domain/usecases/auth/sign_up.dart';
import 'package:e_commerce_client/features/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockSignUp extends Mock implements SignUp {}

class MockLogin extends Mock implements Login {}

class MockGoogleLogin extends Mock implements GoogleLogin {}

class MockFacebookLogin extends Mock implements FacebookLogin {}

class MockCheckStatus extends Mock implements CheckAuthStatus {}

void main() {
  late MockSignUp mockSignUp;
  late MockLogin mockLogin;
  late MockGoogleLogin mockGoogleLogin;
  late MockFacebookLogin mockFacebookLogin;
  late MockCheckStatus mockCheckStatus;
  late AuthBloc authBloc;

  const tFirstName = 'Test';
  const tLastName = 'User';
  const tEmail = 'test@test.com';
  const tPassword = '123456';
  const tPhone = '0123456789';

  final tUserEntity = UserEntity(
    userId: 'u1',
    firstName: tFirstName,
    lastName: tLastName,
    email: tEmail,
    phone: tPhone,
    image: '',
  );

  setUpAll(() {
    registerFallbackValue(
      SignUpParams(
        email: tEmail,
        password: tPassword,
        firstName: tFirstName,
        lastName: tLastName,
        phone: tPhone,
      ),
    );

    registerFallbackValue(LoginParams(email: tEmail, password: tPassword));

    registerFallbackValue(NoParams());
  });

  setUp(() {
    mockSignUp = MockSignUp();
    mockLogin = MockLogin();
    mockGoogleLogin = MockGoogleLogin();
    mockFacebookLogin = MockFacebookLogin();
    mockCheckStatus = MockCheckStatus();
    authBloc = AuthBloc(
      signUp: mockSignUp,
      login: mockLogin,
      googleLogin: mockGoogleLogin,
      facebookLogin: mockFacebookLogin,
      checkAuthStatus: mockCheckStatus,
    );
  });

  group('AuthBloc SignUp', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthSuccess] when signup succeeds',
      build: () {
        when(
          () => mockSignUp(any()),
        ).thenAnswer((_) async => const Right(unit));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthSignUp(
          email: tEmail,
          password: tPassword,
          firstName: tFirstName,
          lastName: tLastName,
          phone: tPhone,
        ),
      ),
      expect: () => [AuthLoading(), AuthSuccess()],
      verify: (_) {
        verify(() => mockSignUp(any())).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthFailure] when signup fails',
      build: () {
        when(
          () => mockSignUp(any()),
        ).thenAnswer((_) async => const Left(Failure('Signup failed')));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthSignUp(
          email: tEmail,
          password: tPassword,
          firstName: tFirstName,
          lastName: tLastName,
          phone: tPhone,
        ),
      ),
      expect: () => [AuthLoading(), const AuthFailure('Signup failed')],
      verify: (_) {
        verify(() => mockSignUp(any())).called(1);
      },
    );
  });

  group('AuthBloc Login', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthSuccess] when login succeeds',
      build: () {
        when(
          () => mockLogin(any()),
        ).thenAnswer((_) async => Right(tUserEntity));
        return authBloc;
      },
      act: (bloc) =>
          bloc.add(const AuthLogin(email: tEmail, password: tPassword)),
      expect: () => [AuthLoading(), AuthAuthenticated(user: tUserEntity)],
      verify: (_) {
        verify(() => mockLogin(any())).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthFailure] when login fails',
      build: () {
        when(
          () => mockLogin(any()),
        ).thenAnswer((_) async => const Left(Failure('Login failed')));
        return authBloc;
      },
      act: (bloc) =>
          bloc.add(const AuthLogin(email: tEmail, password: tPassword)),
      expect: () => [AuthLoading(), const AuthFailure('Login failed')],
      verify: (_) {
        verify(() => mockLogin(any())).called(1);
      },
    );
  });

  group('AuthBloc GoogleLogin', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthSuccess] when google login succeeds',
      build: () {
        when(
          () => mockGoogleLogin(NoParams()),
        ).thenAnswer((_) async => Right(tUserEntity));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthGoogleLogin()),
      expect: () => [AuthLoading(type: AuthLoadingType.google), AuthAuthenticated(user: tUserEntity)],
      verify: (_) {
        verify(() => mockGoogleLogin(NoParams())).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthFailure] when google login fails',
      build: () {
        when(
          () => mockGoogleLogin(NoParams()),
        ).thenAnswer((_) async => const Left(Failure('Google login failed')));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthGoogleLogin()),
      expect: () => [
        AuthLoading(type: AuthLoadingType.google),
        const AuthFailure('Google login failed'),
      ],
      verify: (_) {
        verify(() => mockGoogleLogin(NoParams())).called(1);
      },
    );
  });

  group('AuthBloc FacebookLogin', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthSuccess] when facebook login succeeds',
      build: () {
        when(
          () => mockFacebookLogin(NoParams()),
        ).thenAnswer((_) async => Right(tUserEntity));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthFacebookLogin()),
      expect: () => [AuthLoading(type: AuthLoadingType.facebook), AuthAuthenticated(user: tUserEntity)],
      verify: (_) {
        verify(() => mockFacebookLogin(NoParams())).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthFailure] when facebook login fails',
      build: () {
        when(
          () => mockFacebookLogin(NoParams()),
        ).thenAnswer((_) async => const Left(Failure('Facebook login failed')));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthFacebookLogin()),
      expect: () => [
        AuthLoading(type: AuthLoadingType.facebook),
        const AuthFailure('Facebook login failed'),
      ],
      verify: (_) {
        verify(() => mockFacebookLogin(NoParams())).called(1);
      },
    );
  });
  group('AuthBloc CheckAuthStatus', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthAuthenticated] when user is authenticated',
      build: () {
        when(
          () => mockCheckStatus(NoParams()),
        ).thenAnswer((_) async => Right(tUserEntity));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthCheckStatus()),
      expect: () => [AuthLoading(), AuthAuthenticated(user: tUserEntity)],
      verify: (_) {
        verify(() => mockCheckStatus(NoParams())).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthUnauthenticated] when user is not authenticated',
      build: () {
        when(
          () => mockCheckStatus(NoParams()),
        ).thenAnswer((_) async => const Left(Failure('User is not authenticated')));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthCheckStatus()),
      expect: () => [
        AuthLoading(),
        const AuthUnauthenticated(),
      ],
      verify: (_) {
        verify(() => mockCheckStatus(NoParams())).called(1);
      },
    );
  });
}
