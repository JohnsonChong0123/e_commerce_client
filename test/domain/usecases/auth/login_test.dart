import 'package:e_commerce_client/domain/entity/user_entity.dart';
import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/domain/repositories/auth_repository.dart';
import 'package:e_commerce_client/domain/usecases/auth/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late Login usecase;

  const tParams = LoginParams(email: 'test@test.com', password: '123456');

  const tUserEntity = UserEntity(
    userId: '123',
    firstName: 'Test',
    lastName: 'User',
    email: 'test@test.com',
    phone: '0123456789',
    image: '',
    address: '',
    latitude: 0.0,
    longitude: 0.0,
    wallet: 0.0,
  );

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = Login(mockRepository);
  });

  test(
    'should call repository loginWithEmailPassword and return UserEntity on success',
    () async {
      // arrange
      when(
        () => mockRepository.loginWithEmailPassword(
          email: tParams.email,
          password: tParams.password,
        ),
      ).thenAnswer((_) async => const Right(tUserEntity));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, const Right(tUserEntity));
      verify(
        () => mockRepository.loginWithEmailPassword(
          email: tParams.email,
          password: tParams.password,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return Failure when repository returns Failure', () async {
    // arrange
    const failure = Failure('Server error');

    when(
      () => mockRepository.loginWithEmailPassword(
        email: tParams.email,
        password: tParams.password,
      ),
    ).thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase(tParams);

    // assert
    expect(result, const Left(failure));
    verify(
      () => mockRepository.loginWithEmailPassword(
        email: tParams.email,
        password: tParams.password,
      ),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
