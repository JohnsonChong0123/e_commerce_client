import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/usecase/usecase.dart';
import '../../entity/product_view_entity.dart';
import '../../repositories/product_repository.dart';

class GetProducts implements UseCase<List<ProductViewEntity>, NoParams> {
  final ProductRepository repository;

  GetProducts(this.repository);

  @override
  Future<Either<Failure, List<ProductViewEntity>>> call(NoParams params) async {
    return await repository.getProducts();
  }
}
