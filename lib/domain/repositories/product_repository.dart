import 'package:fpdart/fpdart.dart';
import '../../core/errors/failure.dart';
import '../entity/product_view_entity.dart';

abstract interface class ProductRepository {
  Future<Either<Failure, List<ProductViewEntity>>> getProducts();
}