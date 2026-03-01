import 'package:equatable/equatable.dart';
import '../../../domain/entity/cart_entity.dart';
import 'cart_item_model.dart';

class CartModel extends Equatable {
  final String id;
  final List<CartItemModel> items;
  final double cartTotal;
  const CartModel({
    required this.id,
    required this.items,
    required this.cartTotal,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      items: (json['items'] as List)
          .map((e) => CartItemModel.fromJson(e))
          .toList(),
      cartTotal: (json['cart_total'] as num).toDouble(),
    );
  }

  CartEntity toEntity() {
    return CartEntity(
      id: id,
      items: items.map((model) => model.toEntity()).toList(),
      cartTotal: cartTotal,
    );
  }
  
  @override
  List<Object?> get props => [id, items, cartTotal];
}
