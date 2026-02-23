import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/data/sources/local/user_local_data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage mockFlutterSecureStorage;
  late UserLocalDataImpl userLocalData;

  const tAccessToken = 'access_token';
  const tRefreshToken = 'refresh_token';
  const tProvider = 'provider';

  setUp(() {
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    userLocalData = UserLocalDataImpl(
      flutterSecureStorage: mockFlutterSecureStorage,
    );
  });

  group('saveAuth', () {
    test('should save auth data in secure storage when called', () async {
      // arrange
      when(
        () => mockFlutterSecureStorage.write(
          key: 'access_token',
          value: tAccessToken,
        ),
      ).thenAnswer((_) async {});
      when(
        () => mockFlutterSecureStorage.write(
          key: 'refresh_token',
          value: tRefreshToken,
        ),
      ).thenAnswer((_) async {});
      when(
        () => mockFlutterSecureStorage.write(
          key: 'login_provider',
          value: tProvider,
        ),
      ).thenAnswer((_) async {});

      // act
      await userLocalData.saveAuth(
        accessToken: tAccessToken,
        refreshToken: tRefreshToken,
        provider: tProvider,
      );

      // assert
      verify(
        () => mockFlutterSecureStorage.write(
          key: 'access_token',
          value: tAccessToken,
        ),
      ).called(1);
      verify(
        () => mockFlutterSecureStorage.write(
          key: 'refresh_token',
          value: tRefreshToken,
        ),
      ).called(1);
      verify(
        () => mockFlutterSecureStorage.write(
          key: 'login_provider',
          value: tProvider,
        ),
      ).called(1);
    });

    test('should throw CacheException when write storage fails', () async {
      // arrange
      when(
        () => mockFlutterSecureStorage.write(
          key: 'access_token',
          value: tAccessToken,
        ),
      ).thenThrow(Exception('Storage error'));
      when(
        () => mockFlutterSecureStorage.write(
          key: 'refresh_token',
          value: tRefreshToken,
        ),
      ).thenThrow(Exception('Storage error'));
      when(
        () => mockFlutterSecureStorage.write(
          key: 'login_provider',
          value: tProvider,
        ),
      ).thenThrow(Exception('Storage error'));

      // act
      final result = userLocalData.saveAuth(
        accessToken: tAccessToken,
        refreshToken: tRefreshToken,
        provider: tProvider,
      );

      // assert
      expect(result, throwsA(isA<CacheException>()));
    });
  });

  group('getAccessToken', () {
    test(
      'should return access token from secure storage when called',
      () async {
        // arrange
        when(
          () => mockFlutterSecureStorage.read(key: 'access_token'),
        ).thenAnswer((_) async => tAccessToken);

        // act
        final result = await userLocalData.getAccessToken();

        // assert
        expect(result, tAccessToken);
        verify(
          () => mockFlutterSecureStorage.read(key: 'access_token'),
        ).called(1);
      },
    );

    test('should throw CacheException when get access token fails', () async {
      // arrange
      when(
        () => mockFlutterSecureStorage.read(key: 'access_token'),
      ).thenThrow(Exception('Storage error'));

      // act
      final result = userLocalData.getAccessToken();

      // assert
      expect(result, throwsA(isA<CacheException>()));
    });
  });

  group('getRefreshToken', () {
    test(
      'should return refresh token from secure storage when called',
      () async {
        // arrange
        when(
          () => mockFlutterSecureStorage.read(key: 'refresh_token'),
        ).thenAnswer((_) async => tRefreshToken);

        // act
        final result = await userLocalData.getRefreshToken();

        // assert
        expect(result, tRefreshToken);
        verify(
          () => mockFlutterSecureStorage.read(key: 'refresh_token'),
        ).called(1);
      },
    );

    test('should throw CacheException when get refresh token fails', () async {
      // arrange
      when(
        () => mockFlutterSecureStorage.read(key: 'refresh_token'),
      ).thenThrow(Exception('Storage error'));

      // act
      final result = userLocalData.getRefreshToken();

      // assert
      expect(result, throwsA(isA<CacheException>()));
    });
  });

  group('setAccessToken', () {
    test(
      'should save new access token in secure storage when called',
      () async {
        // arrange
        when(
          () => mockFlutterSecureStorage.write(
            key: 'access_token',
            value: tAccessToken,
          ),
        ).thenAnswer((_) async {});

        // act
        await userLocalData.setAccessToken(tAccessToken);

        // assert
        verify(
          () => mockFlutterSecureStorage.write(
            key: 'access_token',
            value: tAccessToken,
          ),
        ).called(1);
      },
    );

    test('should throw CacheException when set access token fails', () async {
      // arrange
      when(
        () => mockFlutterSecureStorage.write(
          key: 'access_token',
          value: tAccessToken,
        ),
      ).thenThrow(Exception('Storage error'));

      // act
      final result = userLocalData.setAccessToken(tAccessToken);

      // assert
      expect(result, throwsA(isA<CacheException>()));
    });
  });
}
