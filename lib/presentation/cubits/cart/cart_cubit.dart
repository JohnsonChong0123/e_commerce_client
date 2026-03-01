import 'package:e_commerce_client/domain/usecases/cart/get_cart.dart';
import 'package:e_commerce_client/domain/usecases/cart/remove_cart_item.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/usecase/usecase.dart';
import '../../../domain/entity/cart_entity.dart';
import '../../../domain/usecases/cart/add_to_cart.dart';
import '../../../domain/usecases/cart/clear_cart.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final AddToCart _addToCart;
  final GetCart _getCart;
  final RemoveCartItem _removeCartItem;
  final ClearCart _clearCart;

  CartCubit({
    required AddToCart addToCart,
    required GetCart getCart,
    required RemoveCartItem removeCartItem,
    required ClearCart clearCart,
  }) : _addToCart = addToCart,
       _getCart = getCart,
       _removeCartItem = removeCartItem,
       _clearCart = clearCart,
       super(CartInitial());

  Future<void> addToCart({
    required String productId,
    required int quantity,
  }) async {
    emit(CartLoading());
    final result = await _addToCart(
      AddToCartParams(productId: productId, quantity: quantity),
    );
    result.fold(
      (failure) => emit(CartFailure(message: failure.message)),
      (_) => emit(const CartSuccess()),
    );
  }

  Future<void> getCart() async {
    emit(CartLoading());
    final result = await _getCart(NoParams());
    result.fold(
      (failure) => emit(CartFailure(message: failure.message)),
      (carts) => emit(CartLoaded(carts: carts)),
    );
  }

  Future<void> removeCartItem(String productId) async {
    emit(CartLoading());

    final result = await _removeCartItem(
      RemoveCartItemParams(productId: productId),
    );

    result.fold((failure) => emit(CartFailure(message: failure.message)), (
      _,
    ) async {
      final cartResult = await _getCart(NoParams());
      cartResult.fold(
        (failure) => emit(CartFailure(message: failure.message)),
        (carts) => emit(CartLoaded(carts: carts)),
      );
    });
  }

  Future<void> clearCart() async {
    emit(CartLoading());

    final result = await _clearCart(NoParams());

    result.fold((failure) => emit(CartFailure(message: failure.message)), (
      _,
    ) async {
      final cartResult = await _getCart(NoParams());
      cartResult.fold(
        (failure) => emit(CartFailure(message: failure.message)),
        (carts) => emit(CartLoaded(carts: carts)),
      );
    });
  }
}
