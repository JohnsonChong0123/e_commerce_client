import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/core/external/google/google_auth_service.dart';
import 'package:e_commerce_client/features/data/models/auth_response.dart';
import 'package:e_commerce_client/features/data/sources/remote/auth_remote_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockDio extends Mock implements Dio {}

class MockGoogleAuthService extends Mock implements GoogleAuthService {}

void main() {
  late MockDio mockDio;
  late MockGoogleAuthService mockGoogleAuthService;
  late AuthRemoteDataImpl authRemoteData;
  late Map<String, dynamic> tJsonMap;
  late AuthResponse tAuthResponse;

  const tFirstName = 'Test';
  const tLastName = 'User';
  const tEmail = 'test@test.com';
  const tPassword = '123456';
  const tPhone = '0123456789';

  setUpAll(() {
    dotenv.loadFromString(envString: 'SERVER_URL=https://example.com');
    registerFallbackValue(RequestOptions(path: '/auth/register'));
  });

  setUp(() {
    mockDio = MockDio();
    mockGoogleAuthService = MockGoogleAuthService();
    authRemoteData = AuthRemoteDataImpl(
      dio: mockDio,
      googleAuthService: mockGoogleAuthService,
    );

    tJsonMap = jsonDecode(fixture('auth/auth_response.json'));
    tAuthResponse = AuthResponse.fromJson(tJsonMap);
  });

  group('signUpWithEmailPassword', () {
    test('should complete when response code is 200', () async {
      // arrange
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/auth/register'),
          statusCode: 200,
          data: {},
        ),
      );

      // act
      final result = authRemoteData.signUpWithEmailPassword(
        firstName: tFirstName,
        lastName: tLastName,
        email: tEmail,
        password: tPassword,
        phone: tPhone,
      );

      // assert
      expect(result, completes);

      verify(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    test('should throw ServerException on DioException', () async {
      // arrange
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/'),
          message: 'Timeout',
        ),
      );

      // act
      final result = authRemoteData.signUpWithEmailPassword(
        firstName: tFirstName,
        lastName: tLastName,
        email: tEmail,
        password: tPassword,
        phone: tPhone,
      );

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });

    test('should throw ServerException on unknown exception', () async {
      // arrange
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(Exception('boom'));

      // act
      final result = authRemoteData.signUpWithEmailPassword(
        firstName: tFirstName,
        lastName: tLastName,
        email: tEmail,
        password: tPassword,
        phone: tPhone,
      );

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });

  group('loginWithEmailPassword', () {
    test('should return AuthResponse when login success', () async {
      // arrange
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: tJsonMap,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // act
      final result = await authRemoteData.loginWithEmailPassword(
        email: tEmail,
        password: tPassword,
      );

      // assert
      expect(result, equals(tAuthResponse));
      verify(
        () => mockDio.post(
          '/auth/login',
          data: {'email': tEmail, 'password': tPassword},
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    test('should throw ServerException on DioException', () async {
      // arrange
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/'),
          message: 'Timeout',
        ),
      );

      // act
      final result = authRemoteData.loginWithEmailPassword(
        email: tEmail,
        password: tPassword,
      );

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });

    test('should throw ServerException on unknown exception', () async {
      // arrange
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(Exception('boom'));

      // act
      final result = authRemoteData.loginWithEmailPassword(
        email: tEmail,
        password: tPassword,
      );

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });

  group('loginWithGoogle', () {
    const tIdToken = 'test_id_token_12345';
    test('should return AuthResponse when google login success', () async {
      // arrange
      when(
        () => mockGoogleAuthService.getIdToken(),
      ).thenAnswer((_) async => tIdToken);
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: tJsonMap,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // act
      final result = await authRemoteData.loginWithGoogle();

      // assert
      expect(result, equals(tAuthResponse));
      verify(() => mockGoogleAuthService.getIdToken()).called(1);
      verify(
        () => mockDio.post(
          '/auth/google',
          data: {'id_token': tIdToken},
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    test('should throw ServerException on DioException', () async {
      // arrange
      when(
        () => mockGoogleAuthService.getIdToken(),
      ).thenAnswer((_) async => tIdToken);
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/'),
          message: 'Timeout',
        ),
      );

      // act
      final result = authRemoteData.loginWithGoogle();

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });

    test('should throw ServerException on unknown exception', () async {
      // arrange
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(Exception('boom'));

      // act
      final result = authRemoteData.loginWithGoogle();

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });
}
