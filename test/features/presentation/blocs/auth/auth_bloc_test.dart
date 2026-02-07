import 'package:bloc_test/bloc_test.dart';
import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/core/usecase/usecase.dart';
import 'package:e_commerce_client/features/domain/usecases/auth/sign_up.dart';
import 'package:e_commerce_client/features/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockSignUp extends Mock implements SignUp {}

void main() {
  late MockSignUp mockSignUp;
  late AuthBloc authBloc;

  const tFirstName = 'Test';
  const tLastName = 'User';
  const tEmail = 'test@test.com';
  const tPassword = '123456';
  const tPhone = '0123456789';

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

    registerFallbackValue(NoParams());
  });

  setUp(() {
    mockSignUp = MockSignUp();
    authBloc = AuthBloc(signUp: mockSignUp);
  });

  blocTest<AuthBloc, AuthState>(
    'should emit [AuthLoading, AuthSuccess] when signup succeeds',
    build: () {
      when(() => mockSignUp(any())).thenAnswer((_) async => const Right(unit));
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
    expect: () => [
      AuthLoading(),
      const AuthSuccess(
        'Successfully signed up! Please enter your email and password to login.',
      ),
    ],
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
}
