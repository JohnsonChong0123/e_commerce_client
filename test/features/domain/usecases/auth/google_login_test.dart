import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/core/usecase/usecase.dart';
import 'package:e_commerce_client/features/domain/entity/user_entity.dart';
import 'package:e_commerce_client/features/domain/repositories/auth/auth_repository.dart';
import 'package:e_commerce_client/features/domain/usecases/auth/google_login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late GoogleLogin usecase;

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
    usecase = GoogleLogin(mockRepository);
  });

  test(
    'should call repository loginWithGoogle and return UserEntity on success',
    () async {
      // arrange
      when(
        () => mockRepository.loginWithGoogle(),
      ).thenAnswer((_) async => const Right(tUserEntity));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, const Right(tUserEntity));
      verify(() => mockRepository.loginWithGoogle()).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return Failure when repository returns Failure', () async {
    const failure = Failure('Server error');
    // arrange
    when(
      () => mockRepository.loginWithGoogle(),
    ).thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, const Left(failure));
    verify(() => mockRepository.loginWithGoogle()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
