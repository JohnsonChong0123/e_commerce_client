import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/domain/repositories/cart_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/usecase/usecase.dart';

class RemoveCartItem implements UseCase<Unit, RemoveCartItemParams> {
  final CartRepository repository;

  RemoveCartItem(this.repository);

  @override
  Future<Either<Failure, Unit>> call(RemoveCartItemParams params) {
    return repository.removeCartItem(params.productId);
  } 
}

class RemoveCartItemParams extends Equatable {
  final String productId;

  const RemoveCartItemParams({required this.productId});

  @override
  List<Object?> get props => [productId];
}
