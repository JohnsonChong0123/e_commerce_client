import 'package:e_commerce_client/core/errors/failure.dart';
import '../../core/errors/exception.dart';
import '../../domain/entity/product_view_entity.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/repositories/product_repository.dart';
import '../sources/remote/product_remote_data.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteData productRemoteData;

  ProductRepositoryImpl({required this.productRemoteData});

  @override
  Future<Either<Failure, List<ProductViewEntity>>> getProducts() async {
    try {
      final product = await productRemoteData.getProducts();
      return right(product.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
