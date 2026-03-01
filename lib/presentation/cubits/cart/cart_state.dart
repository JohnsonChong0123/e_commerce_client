part of 'cart_cubit.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

final class CartInitial extends CartState {
  const CartInitial();
}

final class CartLoading extends CartState {
  const CartLoading();
}

final class CartSuccess extends CartState {
  const CartSuccess();
}

final class CartLoaded extends CartState {
  final CartEntity carts;

  const CartLoaded({required this.carts});

  @override
  List<Object> get props => [carts];
}

final class CartFailure extends CartState {
  final String message;

  const CartFailure({required this.message});

  @override
  List<Object> get props => [message];
}
