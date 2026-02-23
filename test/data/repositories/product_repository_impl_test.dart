import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/data/models/product_model.dart';
import 'package:e_commerce_client/data/repositories/product_repository_impl.dart';
import 'package:e_commerce_client/data/sources/remote/product_remote_data.dart';
import 'package:e_commerce_client/domain/entity/product_view_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRemoteData extends Mock implements ProductRemoteData {}

void main() {
  late MockProductRemoteData mockProductRemoteData;
  late ProductRepositoryImpl repository;

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

  final tProductEntities = tProductModelList
      .map((model) => model.toEntity())
      .toList();

  setUp(() {
    mockProductRemoteData = MockProductRemoteData();
    repository = ProductRepositoryImpl(
      productRemoteData: mockProductRemoteData,
    );
  });

  test(
    'should return Right(List<ProductViewEntity>) when get product succeeds',
    () async {
      // arrange
      when(
        () => mockProductRemoteData.getProducts(),
      ).thenAnswer((_) async => tProductModelList);

      // act
      final result = await repository.getProducts();

      // assert
      final either = result as Right<Failure, List<ProductViewEntity>>;
      final products = either.value;

      expect(products.length, tProductEntities.length);
      for (var i = 0; i < products.length; i++) {
        expect(products[i].id, tProductEntities[i].id);
        expect(products[i].name, tProductEntities[i].name);
        expect(products[i].description, tProductEntities[i].description);
        expect(products[i].initialPrice, tProductEntities[i].initialPrice);
        expect(products[i].finalPrice, tProductEntities[i].finalPrice);
        expect(products[i].imageUrl, tProductEntities[i].imageUrl);
        expect(products[i].rating, tProductEntities[i].rating);
        expect(products[i].reviewCount, tProductEntities[i].reviewCount);
      }
      verify(() => mockProductRemoteData.getProducts()).called(1);
      verifyNoMoreInteractions(mockProductRemoteData);
    },
  );

  test(
    'should return Left(Failure) when get products throws ServerException',
    () async {
      // arrange
      when(
        () => mockProductRemoteData.getProducts(),
      ).thenThrow(const ServerException('Failed to get products'));

      // act
      final result = await repository.getProducts();

      // assert
      expect(result, equals(left(const Failure('Failed to get products'))));
      verify(() => mockProductRemoteData.getProducts()).called(1);
    },
  );
}
