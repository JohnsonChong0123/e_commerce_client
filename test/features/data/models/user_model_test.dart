import 'package:e_commerce_client/core/entities/user_entity.dart';
import 'package:e_commerce_client/features/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../fixtures/fixture_reader.dart';
import 'dart:convert';

void main() {
  group('UserModel', () {
    late UserModel tUserModel;
    late Map<String, dynamic> tJsonMap;

    setUp(() {
      tUserModel = UserModel(
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
      );

      tJsonMap = jsonDecode(fixture('user/user.json'));
    });

    test('should be a subclass of UserEntity', () {
      // assert
      expect(tUserModel, isA<UserEntity>());
    });

    test('fromJson should return valid UserModel', () {
      // act
      final result = UserModel.fromJson(tJsonMap);

      // assert
      expect(result, equals(tUserModel));
    });

    test('toJson should return correct map', () {
      // act
      final result = tUserModel.toJson();

      // assert
      expect(result, equals(tJsonMap));
    });
  });
}
