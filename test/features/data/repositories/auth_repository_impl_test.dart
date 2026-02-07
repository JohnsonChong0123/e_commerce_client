import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/features/data/repositories/auth_repository_impl.dart';
import 'package:e_commerce_client/features/data/sources/auth_remote_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteData extends Mock implements AuthRemoteData {}

void main() {
  late MockAuthRemoteData mockAuthRemoteData;
  late AuthRepositoryImpl repository;

  const tFirstName = 'Test';
  const tLastName = 'User';
  const tEmail = 'test@test.com';
  const tPassword = '123456';
  const tPhone = '0123456789';

  setUp(() {
    mockAuthRemoteData = MockAuthRemoteData();
    repository = AuthRepositoryImpl(mockAuthRemoteData);
  });

  test('should return Right(unit) when sign up succeeds', () async {
    // arrange
    when(
      () => mockAuthRemoteData.signUpWithEmailPassword(
        firstName: tFirstName,
        lastName: tLastName,
        email: tEmail,
        password: tPassword,
        phone: tPhone,
      ),
    ).thenAnswer((_) async => Future.value());

    // act
    final result = await repository.signUpWithEmailPassword(
      firstName: tFirstName,
      lastName: tLastName,
      email: tEmail,
      password: tPassword,
      phone: tPhone,
    );

    // assert
    expect(result, equals(right(unit)));
    verify(
      () => mockAuthRemoteData.signUpWithEmailPassword(
        firstName: tFirstName,
        lastName: tLastName,
        email: tEmail,
        password: tPassword,
        phone: tPhone,
      ),
    ).called(1);
  });

  test(
    'should return Left(Failure) when sign up throws ServerException',
    () async {
      // arrange
      when(
        () => mockAuthRemoteData.signUpWithEmailPassword(
          firstName: tFirstName,
          lastName: tLastName,
          email: tEmail,
          password: tPassword,
          phone: tPhone,
        ),
      ).thenThrow(const ServerException('Sign up failed'));

      // act
      final result = await repository.signUpWithEmailPassword(
        firstName: tFirstName,
        lastName: tLastName,
        email: tEmail,
        password: tPassword,
        phone: tPhone,
      );
      // assert
      expect(result, equals(left(const Failure('Sign up failed'))));
      verify(
        () => mockAuthRemoteData.signUpWithEmailPassword(
          firstName: tFirstName,
          lastName: tLastName,
          email: tEmail,
          password: tPassword,
          phone: tPhone,
        ),
      ).called(1);
    },
  );
}
