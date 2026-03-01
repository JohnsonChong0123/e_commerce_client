import 'package:fpdart/fpdart.dart';
import '../../core/errors/failure.dart';
import '../entity/cart_entity.dart';

abstract interface class CartRepository {
  Future<Either<Failure, Unit>> addToCart({
    required String productId,
    required int quantity,
  });

  Future<Either<Failure, CartEntity>> getCart();

  Future<Either<Failure, Unit>> removeCartItem(String productId);

  Future<Either<Failure, Unit>> clearCart();
}
