import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/data/models/product_model.dart';
import 'package:e_commerce_client/data/sources/remote/product_remote_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late ProductRemoteDataImpl productRemoteData;
  late List tJsonMap;

  final tProductModelList = [
    ProductModel(
      id: '1',
      name: 'test',
      description: 'description',
      initialPrice: 20.0,
      finalPrice: 15.0,
      imageUrl: 'imageUrl',
      rating: 4.5,
      reviewCount: 100,
    ),

    ProductModel(
      id: '2',
      name: 'test2',
      description: 'description2',
      initialPrice: 10.0,
      finalPrice: 8.0,
      imageUrl: 'imageUrl2',
      rating: 4.0,
      reviewCount: 50,
    ),

    ProductModel(
      id: '3',
      name: 'test3',
      description: 'description3',
      initialPrice: 15.0,
      finalPrice: 12.0,
      imageUrl: 'imageUrl3',
      rating: 4.2,
      reviewCount: 75,
    ),
  ];

  setUpAll(() {
    dotenv.loadFromString(envString: 'SERVER_URL=https://example.com');
    registerFallbackValue(RequestOptions(path: '/test'));
  });

  setUp(() {
    mockDio = MockDio();
    productRemoteData = ProductRemoteDataImpl(dio: mockDio);
    tJsonMap = jsonDecode(fixture('product/product_list.json')) as List;
  });

  test('should return List<ProductModel> when response code is 200', () async {
    // arrange
    when(
      () => mockDio.get(
        '/products/allproduct',
        data: any(named: 'data'),
        options: any(named: 'options'),
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/products/allproduct'),
        statusCode: 200,
        data: tJsonMap,
      ),
    );

    // act
    final result = await productRemoteData.getProducts();

    // assert
    expect(result, equals(tProductModelList));
    verify(
      () => mockDio.get(
        '/products/allproduct',
        data: any(named: 'data'),
        options: any(named: 'options'),
      ),
    ).called(1);
  });

  test('should throw ServerException on DioException', () async {
    // arrange
    when(
      () => mockDio.get(
        '/products/allproduct',
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
    final result = productRemoteData.getProducts();

    // assert
    expect(result, throwsA(isA<ServerException>()));
  });

  test('should throw ServerException on unknown exception', () async {
    // arrange
    when(
      () => mockDio.get(
        '/products/allproduct',
        data: any(named: 'data'),
        options: any(named: 'options'),
      ),
    ).thenThrow(Exception('boom'));

    // act
    final result = productRemoteData.getProducts();

    // assert
    expect(result, throwsA(isA<ServerException>()));
  });
}
