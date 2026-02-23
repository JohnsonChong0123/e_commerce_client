import '../../domain/entity/product_view_entity.dart';

class ProductModel extends ProductViewEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.initialPrice,
    required super.finalPrice,
    required super.imageUrl,
    required super.rating,
    required super.reviewCount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['asin'] ?? '',
      name: json['title'] ?? '',
      description: json['description'] ?? '',
      initialPrice: json['initial_prices'] ?? 0.0,
      finalPrice: json['final_prices'] ?? 0.0,
      imageUrl: json['image_url'] ?? '',
      rating: json['rating'] ?? 0,
      reviewCount: json['reviews_count'] ?? 0,
    );
  }

  ProductViewEntity toEntity() {
    return ProductViewEntity(
      id: id,
      name: name,
      description: description,
      initialPrice: initialPrice,
      finalPrice: finalPrice,
      imageUrl: imageUrl,
      rating: rating,
      reviewCount: reviewCount,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    initialPrice,
    finalPrice,
    imageUrl,
    rating,
    reviewCount,
  ];
}
