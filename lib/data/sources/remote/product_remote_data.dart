import 'package:dio/dio.dart';

import '../../../core/errors/exception.dart';
import '../../models/product_model.dart';

abstract interface class ProductRemoteData {
  Future<List<ProductModel>> getProducts();
}

class ProductRemoteDataImpl implements ProductRemoteData {
  final Dio dio;

  ProductRemoteDataImpl({required this.dio});

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await dio.get('/products/allproduct');
      return (response.data as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      final error = e.error;
      if (error is ServerException) {
        throw error;
      }
      throw ServerException('An unexpected error occurred');
      } catch (e) {
        throw ServerException(e.toString());
    }
  }
}
