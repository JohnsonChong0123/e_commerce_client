import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;

  double get totalPrice => price * quantity;

  const CartItemEntity({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [productId, name, price, quantity, imageUrl];
}
