import 'package:e_commerce_client/features/data/models/product_model.dart';
import 'package:e_commerce_client/features/domain/entity/product_view_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../fixtures/fixture_reader.dart';
import 'dart:convert';

void main() {
  late ProductModel tProductModel;
  late Map<String, dynamic> tJsonMap;

  setUp(() {
    tProductModel = ProductModel(
      id: 'p1',
      name: 'Test Product',
      description: 'This is a test product',
      initialPrice: 100.0,
      finalPrice: 80.0,
      imageUrl: 'product_image.png',
      rating: 4.5,
      reviewCount: 120,
    );

    tJsonMap = jsonDecode(fixture('product/product.json'));
  });

  test('should be a subclass of ProductEntity', () {
    // assert
    expect(tProductModel, isA<ProductViewEntity>());
  });

  test('fromJson should return valid ProductModel', () {
    // act
    final result = ProductModel.fromJson(tJsonMap);

    // assert
    expect(result, equals(tProductModel));
  });

  test('Product.toEntity should convert correctly', () {
    // act
    final tProductEntity = tProductModel.toEntity();

    // assert
    expect(tProductEntity.id, tProductModel.id);
    expect(tProductEntity.name, tProductModel.name);
    expect(tProductEntity.description, tProductModel.description);
    expect(tProductEntity.initialPrice, tProductModel.initialPrice);
    expect(tProductEntity.finalPrice, tProductModel.finalPrice);
    expect(tProductEntity.imageUrl, tProductModel.imageUrl);
    expect(tProductEntity.rating, tProductModel.rating);
    expect(tProductEntity.reviewCount, tProductModel.reviewCount);
  });
}
