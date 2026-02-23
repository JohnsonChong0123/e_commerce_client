import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/domain/repositories/auth_repository.dart';
import 'package:e_commerce_client/domain/usecases/auth/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late SignUp usecase;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = SignUp(mockRepository);
  });

  final tParams = SignUpParams(
    firstName: 'Test',
    lastName: 'User',
    email: 'test@test.com',
    password: '123456',
    phone: '0123456789',
  );

  test(
    'should call repository signUpWithEmailPassword and return Unit on success',
    () async {
      // arrange
      when(
        () => mockRepository.signUpWithEmailPassword(
          firstName: tParams.firstName,
          lastName: tParams.lastName,
          email: tParams.email,
          password: tParams.password,
          phone: tParams.phone,
        ),
      ).thenAnswer((_) async => const Right(unit));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, const Right(unit));
      verify(
        () => mockRepository.signUpWithEmailPassword(
          firstName: tParams.firstName,
          lastName: tParams.lastName,
          email: tParams.email,
          password: tParams.password,
          phone: tParams.phone,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return Failure when repository returns Failure', () async {
    // arrange
    const failure = Failure('Server error');

    when(
      () => mockRepository.signUpWithEmailPassword(
        firstName: tParams.firstName,
        lastName: tParams.lastName,
        email: tParams.email,
        password: tParams.password,
        phone: tParams.phone,
      ),
    ).thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase(tParams);

    // assert
    expect(result, const Left(failure));
    verify(
      () => mockRepository.signUpWithEmailPassword(
        firstName: tParams.firstName,
        lastName: tParams.lastName,
        email: tParams.email,
        password: tParams.password,
        phone: tParams.phone,
      ),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
