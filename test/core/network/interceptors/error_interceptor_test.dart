import 'package:dio/dio.dart';
import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/core/network/interceptors/error_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDioException extends Mock implements DioException {}
class MockErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {}

void main() {
  late MockErrorInterceptorHandler mockErrorInterceptorHandler;
  late ErrorInterceptor interceptor;


  setUpAll(() {
    registerFallbackValue(MockDioException());
  });

  setUp(() {
    interceptor = ErrorInterceptor();
    mockErrorInterceptorHandler = MockErrorInterceptorHandler();
  });

  test('should return "Invalid request" for 400 status code', () {
    // arrange
    final dioException = DioException(
      requestOptions: RequestOptions(),
      response: Response(requestOptions: RequestOptions(), statusCode: 400),
    );

    // act
    interceptor.onError(dioException, mockErrorInterceptorHandler);

    // assert
    verify(
      () => mockErrorInterceptorHandler.reject(
        any(
          that: isA<DioException>().having(
            (e) => (e.error as ServerException).message,
            'message',
            'Invalid request',
          ),
        ),
      ),
    ).called(1);
  });

  test('should return "Invalid email or password" for 401 status code', () {
    // arrange
    final dioException = DioException(
      requestOptions: RequestOptions(),
      response: Response(requestOptions: RequestOptions(), statusCode: 401),
    );

    // act
    interceptor.onError(dioException, mockErrorInterceptorHandler);

    // assert
    verify(
      () => mockErrorInterceptorHandler.reject(
        any(
          that: isA<DioException>().having(
            (e) => (e.error as ServerException).message,
            'message',
            'Invalid email or password',
          ),
        ),
      ),
    ).called(1);
  });

  test('should return "Resource not found" for 404 status code', () {
    // arrange
    final dioException = DioException(
      requestOptions: RequestOptions(),
      response: Response(requestOptions: RequestOptions(), statusCode: 404),
    );

    // act
    interceptor.onError(dioException, mockErrorInterceptorHandler);

    // assert
    verify(
      () => mockErrorInterceptorHandler.reject(
        any(
          that: isA<DioException>().having(
            (e) => (e.error as ServerException).message,
            'message',
            'Resource not found',
          ),
        ),
      ),
    ).called(1);
  });

  test('should return "Email has already been used" for 409 status code', () {
    // arrange
    final dioException = DioException(
      requestOptions: RequestOptions(),
      response: Response(requestOptions: RequestOptions(), statusCode: 409),
    );

    // act
    interceptor.onError(dioException, mockErrorInterceptorHandler);

    // assert
    verify(
      () => mockErrorInterceptorHandler.reject(
        any(
          that: isA<DioException>().having(
            (e) => (e.error as ServerException).message,
            'message',
            'Email has already been used',
          ),
        ),
      ),
    ).called(1);
  });

  test('should return "Server error, please try again later" message for 500 status code', () {
    // arrange
    final dioException = DioException(
      requestOptions: RequestOptions(),
      response: Response(requestOptions: RequestOptions(), statusCode: 500),
      message: 'Server error',
    );

    // act
    interceptor.onError(dioException, mockErrorInterceptorHandler);

    // assert
    verify(
      () => mockErrorInterceptorHandler.reject(
        any(
          that: isA<DioException>().having(
            (e) => (e.error as ServerException).message,
            'message',
            'Server error, please try again later',
          ),
        ),
      ),
    ).called(1);
  });

  test('should return default error message when no response is provided', () {
    // arrange
    final dioException = DioException(
      requestOptions: RequestOptions(),
      message: 'Network error',
    );

    // act
    interceptor.onError(dioException, mockErrorInterceptorHandler);

    // assert
    verify(
      () => mockErrorInterceptorHandler.reject(
        any(
          that: isA<DioException>().having(
            (e) => (e.error as ServerException).message,
            'message',
            'Network error',
          ),
        ),
      ),
    ).called(1);
  });
}
