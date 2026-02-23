import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double initialPrice;
  final double finalPrice;
  final String imageUrl;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.initialPrice,
    required this.finalPrice,
    required this.imageUrl,
  });

  bool get hasDiscount => finalPrice < initialPrice;

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    initialPrice,
    finalPrice,
    imageUrl,
  ];
}
