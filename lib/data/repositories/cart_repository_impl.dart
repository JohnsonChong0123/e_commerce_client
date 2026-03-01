import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/domain/entity/cart_entity.dart';
import 'package:fpdart/fpdart.dart';
import '../../core/errors/exception.dart';
import '../../domain/repositories/cart_repository.dart';
import '../sources/remote/cart_remote_data.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteData cartRemoteData;
  CartRepositoryImpl({required this.cartRemoteData});
  @override
  Future<Either<Failure, Unit>> addToCart({
    required String productId,
    required int quantity,
  }) async {
    try {
      await cartRemoteData.addToCart(productId: productId, quantity: quantity);
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> getCart() async {
    try {
      final cart = await cartRemoteData.getCart();
      return right(cart.toEntity());
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
  
  @override
  Future<Either<Failure, Unit>> removeCartItem(String productId) async {
    try {
      await cartRemoteData.removeCartItem(productId);
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
  
  @override
  Future<Either<Failure, Unit>> clearCart() async {
    try {
      await cartRemoteData.clearCart();
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
