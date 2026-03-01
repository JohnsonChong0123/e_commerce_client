import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/domain/repositories/cart_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/usecase/usecase.dart';

class AddToCart implements UseCase<Unit, AddToCartParams> {
  final CartRepository repository;

  AddToCart(this.repository);

  @override
  Future<Either<Failure, Unit>> call(AddToCartParams params) {
    return repository.addToCart(
      productId: params.productId,
      quantity: params.quantity,
    );
  }
}

class AddToCartParams extends Equatable {
  final String productId;
  final int quantity;

  const AddToCartParams({required this.productId, required this.quantity});

  @override
  List<Object?> get props => [productId, quantity];
}
