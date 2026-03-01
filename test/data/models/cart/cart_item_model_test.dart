import 'package:e_commerce_client/data/models/cart/cart_item_model.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../fixtures/fixture_reader.dart';
import 'dart:convert';

void main() {
  late CartItemModel tCartItemModel;
  late Map<String, dynamic> tJsonMap;

  setUp(() {
    tCartItemModel = CartItemModel(
      productId: 'B09NQJFRW6',
      name: 'Saucony Men\'s Kinvara 13 Running Shoe',
      price: 57.79,
      quantity: 3,
      imageUrl: 'https://m.media-amazon.com/images/I/71QeGmahUnL._AC_UX500_.jpg'
    );

    tJsonMap = jsonDecode(fixture('cart/cart_item.json'));
  });

  test('fromJson should return valid CartItemModel', () {
    // act
    final result = CartItemModel.fromJson(tJsonMap);

    // assert
    expect(result, equals(tCartItemModel));
  });

  test('CartItemModel.toEntity should convert correctly', () {
    // act
    final tCartItemEntity = tCartItemModel.toEntity();

    // assert
    expect(tCartItemEntity.productId, tCartItemModel.productId);
    expect(tCartItemEntity.name, tCartItemModel.name);
    expect(tCartItemEntity.price, tCartItemModel.price);
    expect(tCartItemEntity.quantity, tCartItemModel.quantity);
    expect(tCartItemEntity.imageUrl, tCartItemModel.imageUrl);
  });
}
