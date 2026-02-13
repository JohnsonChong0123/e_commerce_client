import 'package:dio/dio.dart';
import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/core/network/interceptors/error_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDioException extends Mock implements DioException {}
class MockErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {}


void main() {
  late ErrorInterceptor errorInterceptor;
  late MockErrorInterceptorHandler mockErrorInterceptorHandler;

  setUpAll(() {
    registerFallbackValue(MockDioException());
  });

  setUp(() {
    errorInterceptor = ErrorInterceptor();
    mockErrorInterceptorHandler = MockErrorInterceptorHandler();
  });

  test('should return "Email has already been used" for 409 status code', () {
    // arrange
    final dioException = DioException(
      requestOptions: RequestOptions(),
      response: Response(requestOptions: RequestOptions(), statusCode: 409),
    );

    // act
    errorInterceptor.onError(dioException, mockErrorInterceptorHandler);

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
}
