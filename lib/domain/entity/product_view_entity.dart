import 'product_entity.dart';

class ProductViewEntity extends ProductEntity {
  final double rating;
  final int reviewCount;

  const ProductViewEntity({
    required super.id,
    required super.name,
    required super.description,
    required super.initialPrice,
    required super.finalPrice,
    required super.imageUrl,
    required this.rating,
    required this.reviewCount,
  });

  @override
  List<Object?> get props => [...super.props, rating, reviewCount];
}
