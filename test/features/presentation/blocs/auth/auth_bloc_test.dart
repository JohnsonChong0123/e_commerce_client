import 'package:bloc_test/bloc_test.dart';
import 'package:e_commerce_client/features/domain/entity/user_entity.dart';
import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/core/usecase/usecase.dart';
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

void main() {
  late MockSignUp mockSignUp;
  late MockLogin mockLogin;
  late MockGoogleLogin mockGoogleLogin;
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
    authBloc = AuthBloc(
      signUp: mockSignUp,
      login: mockLogin,
      googleLogin: mockGoogleLogin,
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
      expect: () => [AuthLoading(), AuthSuccess()],
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
      expect: () => [AuthLoading(type: AuthLoadingType.google), AuthSuccess()],
      verify: (_) {
        verify(() => mockGoogleLogin(NoParams())).called(1);
      },
    );

    // blocTest<AuthBloc, AuthState>(
    //   'should emit [AuthLoading, AuthFailure] when login fails',
    //   build: () {
    //     when(
    //       () => mockLogin(any()),
    //     ).thenAnswer((_) async => const Left(Failure('Login failed')));
    //     return authBloc;
    //   },
    //   act: (bloc) =>
    //       bloc.add(const AuthLogin(email: tEmail, password: tPassword)),
    //   expect: () => [AuthLoading(), const AuthFailure('Login failed')],
    //   verify: (_) {
    //     verify(() => mockLogin(any())).called(1);
    //   },
    // );
  });
}
