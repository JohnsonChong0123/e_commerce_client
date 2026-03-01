import 'package:equatable/equatable.dart';

import '../../../domain/entity/cart_item_entity.dart';

class CartItemModel extends Equatable {
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;
  const CartItemModel({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['product_id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] ?? 0,
      imageUrl: json['image_url'] ?? '',
    );
  }

  CartItemEntity toEntity() {
    return CartItemEntity(
      productId: productId,
      name: name,
      price: price,
      quantity: quantity,
      imageUrl: imageUrl,
    );
  }

  @override
  List<Object?> get props => [productId, name, price, quantity, imageUrl];
}
