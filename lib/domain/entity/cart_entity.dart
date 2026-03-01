import 'package:equatable/equatable.dart';

import 'cart_item_entity.dart';

class CartEntity extends Equatable {
  final String id;
  final List<CartItemEntity> items;
  final double cartTotal;

  const CartEntity({
    required this.id,
    required this.items,
    required this.cartTotal,
  });

  @override
  List<Object?> get props => [id, items, cartTotal];
}
