import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/data/models/cart/cart_model.dart';
import 'package:e_commerce_client/data/sources/remote/cart_remote_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late CartRemoteDataImpl cartRemoteData;
  late Map<String, dynamic> tJsonMap;
  late CartModel tCartModel;

  const tProductId = '1';
  const tQuantity = 2;

  setUp(() {
    mockDio = MockDio();
    cartRemoteData = CartRemoteDataImpl(dio: mockDio);

    tJsonMap = jsonDecode(fixture('cart/cart.json'));
    tCartModel = CartModel.fromJson(tJsonMap);
  });

  group('addToCart', () {
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
          requestOptions: RequestOptions(path: '/carts/add'),
          statusCode: 200,
          data: {},
        ),
      );

      // act
      final result = cartRemoteData.addToCart(
        productId: tProductId,
        quantity: tQuantity,
      );

      // assert
      expect(result, completes);

      verify(
        () => mockDio.post(
          '/carts/add',
          data: {'product_id': tProductId, 'quantity': tQuantity},
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    test('should throw ServerException on DioException', () async {
      // arrange
      when(
        () => mockDio.post(
          '/carts/add',
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
      final result = cartRemoteData.addToCart(
        productId: tProductId,
        quantity: tQuantity,
      );

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });

    test('should throw ServerException on unknown exception', () async {
      // arrange
      when(
        () => mockDio.post(
          '/carts/add',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(Exception('boom'));

      // act
      final result = cartRemoteData.addToCart(
        productId: tProductId,
        quantity: tQuantity,
      );

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });

  group('getCart', () {
    test('should return CartModel when get cart success', () async {
      // arrange
      when(
        () => mockDio.get(
          '/carts',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: tJsonMap,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/carts'),
        ),
      );

      // act
      final result = await cartRemoteData.getCart();

      // assert
      expect(result, equals(tCartModel));
      verify(
        () => mockDio.get('/carts', options: any(named: 'options')),
      ).called(1);
    });

    test('should throw ServerException on DioException', () async {
      // arrange
      when(
        () => mockDio.get(
          '/carts',
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
      final result = cartRemoteData.getCart();

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });

    test('should throw ServerException on unknown exception', () async {
      // arrange
      when(
        () => mockDio.get(
          '/carts',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(Exception('boom'));

      // act
      final result = cartRemoteData.getCart();

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });

  group('removeCartItem', () {
    test('should complete when remove cart item success', () async {
      // arrange
      when(
        () => mockDio.delete(
          '/carts/remove/$tProductId',
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/carts/remove/$tProductId'),
          statusCode: 200,
          data: {},
        ),
      );

      // act
      final result = cartRemoteData.removeCartItem(tProductId);

      // assert
      expect(result, completes);

      verify(
        () => mockDio.delete(
          '/carts/remove/$tProductId',
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    test('should throw ServerException on DioException', () async {
      // arrange
      when(
        () => mockDio.delete(
          '/carts/remove/$tProductId',
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/'),
          message: 'Timeout',
        ),
      );

      // act
      final result = cartRemoteData.removeCartItem(tProductId);

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });

    test('should throw ServerException on unknown exception', () async {
      // arrange
      when(
        () => mockDio.delete(
          '/carts/remove/$tProductId',
          options: any(named: 'options'),
        ),
      ).thenThrow(Exception('boom'));

      // act
      final result = cartRemoteData.removeCartItem(tProductId);

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });

  group('clearCart', () {
    test('should complete when clear cart success', () async {
      // arrange
      when(
        () => mockDio.delete(
          '/carts/clear',
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/carts/clear'),
          statusCode: 200,
          data: {},
        ),
      );

      // act
      final result = cartRemoteData.clearCart();

      // assert
      expect(result, completes);

      verify(
        () => mockDio.delete(
          '/carts/clear',
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    test('should throw ServerException on DioException', () async {
      // arrange
      when(
        () => mockDio.delete(
          '/carts/clear',
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/'),
          message: 'Timeout',
        ),
      );

      // act
      final result = cartRemoteData.clearCart();

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });

    test('should throw ServerException on unknown exception', () async {
      // arrange
      when(
        () => mockDio.delete(
          '/carts/clear',
          options: any(named: 'options'),
        ),
      ).thenThrow(Exception('boom'));

      // act
      final result = cartRemoteData.clearCart();

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });
}
