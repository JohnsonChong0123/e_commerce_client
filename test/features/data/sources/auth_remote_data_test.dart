import 'package:dio/dio.dart';
import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/features/data/sources/auth_remote_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late AuthRemoteDataImpl mockAuthRemoteDataImpl;

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
    mockAuthRemoteDataImpl = AuthRemoteDataImpl(dio: mockDio);
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
      final result = mockAuthRemoteDataImpl.signUpWithEmailPassword(
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
          data: {
            "first_name": tFirstName,
            "last_name": tLastName,
            "email": tEmail,
            "password": tPassword,
            "phone": tPhone,
          },
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    test('should throw ServerException when status code != 200', () async {
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
          statusCode: 400,
          data: {'detail': 'Email exists'},
        ),
      );

      // act
      final result = mockAuthRemoteDataImpl.signUpWithEmailPassword(
        firstName: tFirstName,
        lastName: tLastName,
        email: tEmail,
        password: tPassword,
        phone: tPhone,
      );

      // assert
      expect(result, throwsA(isA<ServerException>()));
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
      final result = mockAuthRemoteDataImpl.signUpWithEmailPassword(
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
      final result = mockAuthRemoteDataImpl.signUpWithEmailPassword(
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
}
