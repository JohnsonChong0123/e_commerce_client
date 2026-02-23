import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/core/usecase/usecase.dart';
import 'package:e_commerce_client/domain/entity/user_entity.dart';
import 'package:e_commerce_client/domain/repositories/auth_repository.dart';
import 'package:e_commerce_client/domain/usecases/auth/facebook_login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late FacebookLogin usecase;

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
    usecase = FacebookLogin(mockRepository);
  });

  test(
    'should call repository loginWithFacebook and return UserEntity on success',
    () async {
      // arrange
      when(
        () => mockRepository.loginWithFacebook(),
      ).thenAnswer((_) async => const Right(tUserEntity));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, const Right(tUserEntity));
      verify(() => mockRepository.loginWithFacebook()).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return Failure when repository returns Failure', () async {
    const failure = Failure('Server error');
    // arrange
    when(
      () => mockRepository.loginWithFacebook(),
    ).thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, const Left(failure));
    verify(() => mockRepository.loginWithFacebook()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}