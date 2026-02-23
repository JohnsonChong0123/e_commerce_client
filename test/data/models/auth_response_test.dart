import 'package:e_commerce_client/data/models/auth_response.dart';
import 'package:e_commerce_client/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../fixtures/fixture_reader.dart';
import 'dart:convert';

void main() {
  late AuthResponse tAuthResponse;
  late Map<String, dynamic> tJsonMap;

  setUp(() {
    tAuthResponse = AuthResponse(
      user: UserModel(
        userId: 'u1',
        firstName: 'Test',
        lastName: 'User',
        email: 'test@test.com',
        phone: '0123456789',
        image: 'avatar.png',
        address: 'KL',
        latitude: 3.14,
        longitude: 101.69,
        wallet: 50.0,
      ),
      accessToken: 'access_token',
      refreshToken: 'refresh_token',
      provider: 'provider',
    );

    tJsonMap = jsonDecode(fixture('auth/auth_response.json'));
  });

  test('fromJson should return valid AuthResponse', () {
    // act
    final result = AuthResponse.fromJson(tJsonMap);

    // assert
    expect(result, equals(tAuthResponse));
  });
}
