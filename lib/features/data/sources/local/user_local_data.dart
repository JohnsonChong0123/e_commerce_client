import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/errors/exception.dart';

abstract interface class UserLocalData {
  Future<void> saveAuth({
    required String accessToken,
    required String refreshToken,
    required String provider,
  });
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
}
