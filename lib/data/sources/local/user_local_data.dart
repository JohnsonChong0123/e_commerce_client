import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/errors/exception.dart';

abstract interface class UserLocalData {
  Future<void> saveAuth({
    required String accessToken,
    required String refreshToken,
    required String provider,
  });

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<void> setAccessToken(String accessToken);
}

class UserLocalDataImpl implements UserLocalData {
  final FlutterSecureStorage flutterSecureStorage;
  UserLocalDataImpl({required this.flutterSecureStorage});

  @override
  Future<void> saveAuth({
    required String accessToken,
    required String refreshToken,
    required String provider,
  }) async {
    try {
      await flutterSecureStorage.write(key: 'access_token', value: accessToken);
      await flutterSecureStorage.write(
        key: 'refresh_token',
        value: refreshToken,
      );
      await flutterSecureStorage.write(key: 'login_provider', value: provider);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      final accessToken = await flutterSecureStorage.read(key: 'access_token');
      return accessToken;
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      final refreshToken = await flutterSecureStorage.read(
        key: 'refresh_token',
      );
      return refreshToken;
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> setAccessToken(String accessToken) async {
    try {
      await flutterSecureStorage.write(key: 'access_token', value: accessToken);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }
}
