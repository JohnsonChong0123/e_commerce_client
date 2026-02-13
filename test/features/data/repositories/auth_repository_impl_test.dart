import 'package:e_commerce_client/features/domain/entity/user_entity.dart';
import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/features/data/models/auth_response.dart';
import 'package:e_commerce_client/features/data/models/user_model.dart';
import 'package:e_commerce_client/features/data/repositories/auth_repository_impl.dart';
import 'package:e_commerce_client/features/data/sources/local/user_local_data.dart';
import 'package:e_commerce_client/features/data/sources/remote/auth_remote_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteData extends Mock implements AuthRemoteData {}

class MockUserLocalData extends Mock implements UserLocalData {}

void main() {
  late MockAuthRemoteData mockAuthRemoteData;
  late MockUserLocalData mockUserLocalData;
  late AuthRepositoryImpl repository;

  const tFirstName = 'Test';
  const tLastName = 'User';
  const tEmail = 'test@test.com';
  const tPassword = '123456';
  const tPhone = '0123456789';

  final tAuthResponse = AuthResponse(
    user: UserModel(
      userId: '123',
      firstName: tFirstName,
      lastName: tLastName,
      email: tEmail,
      phone: tPhone,
      image: '',
      address: '',
      latitude: 0.0,
      longitude: 0.0,
      wallet: 0.0,
    ),
    accessToken: 'access_token',
    refreshToken: 'refresh_token',
    provider: 'provider',
  );

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
    mockAuthRemoteData = MockAuthRemoteData();
    mockUserLocalData = MockUserLocalData();
    repository = AuthRepositoryImpl(
      authRemoteData: mockAuthRemoteData,
      userLocalData: mockUserLocalData,
    );
  });

  group('signUpWithEmailPassword', () {
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
      ).thenAnswer((_) async {});

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
  });

  group('loginWithEmailPassword', () {
    test('should return Right(UserEntity) when sign up succeeds', () async {
      // arrange
      when(
        () => mockAuthRemoteData.loginWithEmailPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).thenAnswer((_) async => tAuthResponse);

      when(
        () => mockUserLocalData.saveAuth(
          accessToken: tAuthResponse.accessToken,
          refreshToken: tAuthResponse.refreshToken,
          provider: tAuthResponse.provider,
        ),
      ).thenAnswer((_) async {});

      // act
      final result = await repository.loginWithEmailPassword(
        email: tEmail,
        password: tPassword,
      );

      // assert
      expect(result, equals(right(tUserEntity)));
      verify(
        () => mockAuthRemoteData.loginWithEmailPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);

      verify(
        () => mockUserLocalData.saveAuth(
          accessToken: tAuthResponse.accessToken,
          refreshToken: tAuthResponse.refreshToken,
          provider: tAuthResponse.provider,
        ),
      ).called(1);

      verifyNoMoreInteractions(mockAuthRemoteData);
      verifyNoMoreInteractions(mockUserLocalData);
    });

    test(
      'should return Left(Failure) when login throws ServerException',
      () async {
        // arrange
        when(
          () => mockAuthRemoteData.loginWithEmailPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(const ServerException('Invalid credentials'));

        // act
        final result = await repository.loginWithEmailPassword(
          email: tEmail,
          password: tPassword,
        );

        // assert
        expect(result, equals(left(const Failure('Invalid credentials'))));
        verify(
          () => mockAuthRemoteData.loginWithEmailPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);

        verifyNever(
          () => mockUserLocalData.saveAuth(
            accessToken: tAuthResponse.accessToken,
            refreshToken: tAuthResponse.refreshToken,
            provider: tAuthResponse.provider,
          ),
        );
      },
    );
  });

  group('loginWithGoogle', () {
    test(
      'should return Right(UserEntity) when google login succeeds',
      () async {
        // arrange
        when(
          () => mockAuthRemoteData.loginWithGoogle(),
        ).thenAnswer((_) async => tAuthResponse);

        when(
          () => mockUserLocalData.saveAuth(
            accessToken: tAuthResponse.accessToken,
            refreshToken: tAuthResponse.refreshToken,
            provider: tAuthResponse.provider,
          ),
        ).thenAnswer((_) async {});

        // act
        final result = await repository.loginWithGoogle();

        // assert
        expect(result, equals(right(tUserEntity)));
        verifyInOrder([
          () => mockAuthRemoteData.loginWithGoogle(),
          () => mockUserLocalData.saveAuth(
            accessToken: tAuthResponse.accessToken,
            refreshToken: tAuthResponse.refreshToken,
            provider: tAuthResponse.provider,
          ),
        ]);
        verifyNoMoreInteractions(mockAuthRemoteData);
        verifyNoMoreInteractions(mockUserLocalData);
      },
    );
  });

  test(
    'should return Left(Failure) when google login throws ServerException',
    () async {
      // arrange
      when(
        () => mockAuthRemoteData.loginWithGoogle(),
      ).thenThrow(const ServerException('Invalid credentials'));

      // act
      final result = await repository.loginWithGoogle();

      // assert
      expect(result, equals(left(const Failure('Invalid credentials'))));
      verify(() => mockAuthRemoteData.loginWithGoogle()).called(1);
      verifyNever(
        () => mockUserLocalData.saveAuth(
          accessToken: tAuthResponse.accessToken,
          refreshToken: tAuthResponse.refreshToken,
          provider: tAuthResponse.provider,
        ),
      );
      verifyNoMoreInteractions(mockAuthRemoteData);
      verifyNoMoreInteractions(mockUserLocalData);
    },
  );

  test(
    'should return Left(Failure) when google login throws CacheException',
    () async {
      // arrange
      when(
        () => mockAuthRemoteData.loginWithGoogle(),
      ).thenAnswer((_) async => tAuthResponse);

      when(
        () => mockUserLocalData.saveAuth(
          accessToken: tAuthResponse.accessToken,
          refreshToken: tAuthResponse.refreshToken,
          provider: tAuthResponse.provider,
        ),
      ).thenThrow(const CacheException('Storage error'));

      // act
      final result = await repository.loginWithGoogle();

      // assert
      expect(result, equals(left(const Failure('Storage error'))));
      verifyInOrder([
        () => mockAuthRemoteData.loginWithGoogle(),
        () => mockUserLocalData.saveAuth(
          accessToken: tAuthResponse.accessToken,
          refreshToken: tAuthResponse.refreshToken,
          provider: tAuthResponse.provider,
        ),
      ]);
      verifyNoMoreInteractions(mockAuthRemoteData);
      verifyNoMoreInteractions(mockUserLocalData);
    },
  );
}
