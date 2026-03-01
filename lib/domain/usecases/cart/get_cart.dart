import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/domain/repositories/cart_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/usecase/usecase.dart';
import '../../entity/cart_entity.dart';

class GetCart implements UseCase<CartEntity, NoParams> {
  final CartRepository repository;

  GetCart(this.repository);

  @override
  Future<Either<Failure, CartEntity>> call(NoParams params) {
    return repository.getCart();
  }
}
