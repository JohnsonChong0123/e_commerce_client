import 'package:e_commerce_client/data/models/cart/cart_item_model.dart';
import 'package:e_commerce_client/data/models/cart/cart_model.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../fixtures/fixture_reader.dart';
import 'dart:convert';

void main() {
  late CartModel tCartModel;
  late Map<String, dynamic> tJsonMap;

  setUp(() {
    tCartModel = CartModel(
      id: '1d3ed0a0-b460-4137-81b6-7e4befc3b63b',
      items: [
        CartItemModel(
          productId: 'B09NQJFRW6',
          name: 'Saucony Men\'s Kinvara 13 Running Shoe',
          price: 57.79,
          quantity: 3,
          imageUrl: 'https://m.media-amazon.com/images/I/71QeGmahUnL._AC_UX500_.jpg'
        ),
        CartItemModel(
          productId: 'B0CY242B8P',
          name:
              '4th of July Door Sign Independence Day Wreath Patriotic Door Decoration Flower US Wooden Sign for Memorial Day Front for Door Decor 12 Inch Outdoor',
          price: 7.99,
          quantity: 3,
          imageUrl: 'https://m.media-amazon.com/images/I/81BvLYGKcuL._AC_SL1500_.jpg'
        ),
      ],
      cartTotal: 197.34,
    );

    tJsonMap = jsonDecode(fixture('cart/cart.json'));
  });

  test('fromJson should return valid CartModel', () {
    // act
    final result = CartModel.fromJson(tJsonMap);

    // assert
    expect(result, equals(tCartModel));
  });

  test('CartModel.toEntity should convert correctly', () {
    // act
    final tCartEntity = tCartModel.toEntity();

    // assert
    expect(tCartEntity.id, tCartModel.id);
    expect(tCartEntity.items, tCartModel.items.map((item) => item.toEntity()).toList());
    expect(tCartEntity.cartTotal, tCartModel.cartTotal);
  });
}
