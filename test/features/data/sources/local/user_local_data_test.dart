import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/features/data/sources/local/user_local_data.dart';
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
}
