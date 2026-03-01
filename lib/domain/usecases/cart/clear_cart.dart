import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/domain/repositories/cart_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/usecase/usecase.dart';

class ClearCart implements UseCase<Unit, NoParams> {
  final CartRepository repository;

  ClearCart(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return repository.clearCart();
  }
}
