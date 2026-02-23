import 'package:dio/dio.dart';
import 'package:e_commerce_client/core/network/interceptors/auth_interceptor.dart';
import 'package:e_commerce_client/data/sources/local/user_local_data.dart';
import 'package:e_commerce_client/data/sources/remote/auth_remote_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockUserLocalData extends Mock implements UserLocalData {}

class MockAuthRemoteData extends Mock implements AuthRemoteData {}

class MockRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler {}

class MockErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {}

void main() {
  late MockDio mockDio;
  late MockUserLocalData mockUserLocalData;
  late MockAuthRemoteData mockAuthRemoteData;
  late MockRequestInterceptorHandler mockRequestHandler;
  late MockErrorInterceptorHandler mockErrorHandler;
  late AuthInterceptor interceptor;

  const tAccessToken = 'access_token';
  const tRefreshToken = 'refresh_token';
  const tNewAccessToken = 'new_access_token';

  setUp(() {
    mockDio = MockDio();
    mockUserLocalData = MockUserLocalData();
    mockAuthRemoteData = MockAuthRemoteData();
    mockRequestHandler = MockRequestInterceptorHandler();
    mockErrorHandler = MockErrorInterceptorHandler();

    interceptor = AuthInterceptor(
      dio: mockDio,
      userLocalData: mockUserLocalData,
      getAuthRemoteData: () => mockAuthRemoteData,
    );
  });

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
    registerFallbackValue(Response(requestOptions: RequestOptions(path: '')));
  });

  RequestOptions makeOptions() => RequestOptions(path: '/test');

  DioException makeDioException({
    required RequestOptions options,
    int? statusCode,
  }) {
    return DioException(
      requestOptions: options,
      response: statusCode != null
          ? Response(requestOptions: options, statusCode: statusCode)
          : null,
    );
  }

  group('onRequest', () {
    test('token exists in local data, should be added to header', () async {
      final options = makeOptions();
      // arrange
      when(
        () => mockUserLocalData.getAccessToken(),
      ).thenAnswer((_) async => tAccessToken);

      // act
      await interceptor.onRequest(options, mockRequestHandler);

      // assert
      expect(options.headers['Authorization'], 'Bearer $tAccessToken');
      verify(() => mockUserLocalData.getAccessToken()).called(1);
      verify(() => mockRequestHandler.next(options)).called(1);
    });

    test('token does not exist in local data, should not add header', () async {
      final options = makeOptions();
      // arrange
      when(
        () => mockUserLocalData.getAccessToken(),
      ).thenAnswer((_) async => null);

      // act
      await interceptor.onRequest(options, mockRequestHandler);

      // assert
      expect(options.headers['Authorization'], isNull);
      verify(() => mockUserLocalData.getAccessToken()).called(1);
      verify(() => mockRequestHandler.next(options)).called(1);
    });
  });

  group('onError', () {
    test('should trigger handler.next when error is not 401', () async {
      final options = makeOptions();
      // arrange
      final error = makeDioException(options: options, statusCode: 500);

      // act
      await interceptor.onError(error, mockErrorHandler);

      // assert
      verify(() => mockErrorHandler.next(error)).called(1);
    });

    test(
      'should apply new token and retry request and resolve when error is 401',
      () async {
        final options = makeOptions();
        final error = makeDioException(options: options, statusCode: 401);

        // arrange
        when(
          () => mockUserLocalData.getRefreshToken(),
        ).thenAnswer((_) async => tRefreshToken);
        when(
          () => mockAuthRemoteData.refreshToken(tRefreshToken),
        ).thenAnswer((_) async => tNewAccessToken);
        when(
          () => mockUserLocalData.setAccessToken(tNewAccessToken),
        ).thenAnswer((_) async => {});
        when(() => mockDio.fetch(any())).thenAnswer(
          (_) async => Response(requestOptions: options, statusCode: 200),
        );

        // act
        await interceptor.onError(error, mockErrorHandler);

        // assert
        verify(
          () => mockUserLocalData.setAccessToken(tNewAccessToken),
        ).called(1);

        // Capture the request options passed to dio.fetch
        final captured = verify(() => mockDio.fetch(captureAny())).captured;
        final retryOptions = captured.first as RequestOptions;
        expect(
          retryOptions.headers['Authorization'],
          'Bearer $tNewAccessToken',
        );

        verify(() => mockErrorHandler.resolve(any())).called(1);
      },
    );

    test(
      'should reject original error when error is 401 and refresh token is null',
      () async {
        final options = makeOptions();
        final err = makeDioException(options: options, statusCode: 401);
        // arrange
        when(
          () => mockUserLocalData.getRefreshToken(),
        ).thenAnswer((_) async => null);

        // act
        await interceptor.onError(err, mockErrorHandler);

        // assert
        verify(() => mockErrorHandler.reject(err)).called(1);
        verifyNever(() => mockErrorHandler.resolve(any()));
      },
    );

    test(
      'should reject original error when error is 401 and authRemoteData return null token',
      () async {
        final options = makeOptions();
        final err = makeDioException(options: options, statusCode: 401);

        // arrange
        when(
          () => mockUserLocalData.getRefreshToken(),
        ).thenAnswer((_) async => tRefreshToken);
        when(
          () => mockAuthRemoteData.refreshToken(tRefreshToken),
        ).thenAnswer((_) async => null);

        // act
        await interceptor.onError(err, mockErrorHandler);

        // assert
        verify(() => mockErrorHandler.reject(err)).called(1);
        verifyNever(() => mockErrorHandler.resolve(any()));
      },
    );

    test(
      'should reject original error when error is 401 and dio.fetch throws an error',
      () async {
        final options = makeOptions();
        final err = makeDioException(options: options, statusCode: 401);

        when(
          () => mockUserLocalData.getRefreshToken(),
        ).thenAnswer((_) async => tRefreshToken);
        when(
          () => mockAuthRemoteData.refreshToken(tRefreshToken),
        ).thenAnswer((_) async => tNewAccessToken);
        when(
          () => mockUserLocalData.setAccessToken(tNewAccessToken),
        ).thenAnswer((_) async {});
        when(
          () => mockDio.fetch(any()),
        ).thenThrow(DioException(requestOptions: options));

        await interceptor.onError(err, mockErrorHandler);

        verify(() => mockErrorHandler.reject(err)).called(1);
        verifyNever(() => mockErrorHandler.resolve(any()));
      },
    );

    test(
      'should skip token refresh when requiredAuth is false and error is 401',
      () async {
        final options = makeOptions()..extra['requiredAuth'] = false;
        final err = makeDioException(options: options, statusCode: 401);

        // act
        await interceptor.onError(err, mockErrorHandler);

        // assert
        verify(() => mockErrorHandler.next(err)).called(1);
        verifyNever(() => mockUserLocalData.getRefreshToken());
        verifyNever(() => mockErrorHandler.resolve(any()));
      },
    );

    test(
      'should refresh token when requiredAuth is true and error is 401',
      () async {
        final options = makeOptions()..extra['requiredAuth'] = true;
        final err = makeDioException(options: options, statusCode: 401);

        // arrange
        when(
          () => mockUserLocalData.getRefreshToken(),
        ).thenAnswer((_) async => tRefreshToken);
        when(
          () => mockAuthRemoteData.refreshToken(tRefreshToken),
        ).thenAnswer((_) async => tNewAccessToken);
        when(
          () => mockUserLocalData.setAccessToken(tNewAccessToken),
        ).thenAnswer((_) async => {});
        when(() => mockDio.fetch(any())).thenAnswer(
          (_) async => Response(requestOptions: options, statusCode: 200),
        );

        // act
        await interceptor.onError(err, mockErrorHandler);

        // assert
        verify(() => mockUserLocalData.getRefreshToken()).called(1);
        verify(() => mockErrorHandler.resolve(any())).called(1);
      },
    );
  });
}
