import 'package:dio/dio.dart';

import '../../../core/errors/exception.dart';
import '../../models/cart/cart_model.dart';

abstract interface class CartRemoteData {
  Future<void> addToCart({required String productId, required int quantity});
  Future<CartModel> getCart();
  Future<void> removeCartItem(String productId);
  Future<void> clearCart();
}

class CartRemoteDataImpl implements CartRemoteData {
  final Dio dio;

  CartRemoteDataImpl({required this.dio});

  @override
  Future<void> addToCart({
    required String productId,
    required int quantity,
  }) async {
    try {
      await dio.post(
        '/carts/add',
        options: Options(
          headers: {'Content-Type': 'application/json'},
          extra: {'requiredAuth': true},
        ),
        data: {'product_id': productId, 'quantity': quantity},
      );
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

  @override
  Future<CartModel> getCart() async {
    try {
      final response = await dio.get(
        '/carts',
        options: Options(
          headers: {'Content-Type': 'application/json'},
          extra: {'requiredAuth': true},
        ),
      );
      return CartModel.fromJson(response.data);
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

  @override
  Future<void> removeCartItem(String productId) async {
    try {
      await dio.delete(
        '/carts/remove/$productId',
        options: Options(
          headers: {'Content-Type': 'application/json'},
          extra: {'requiredAuth': true},
        ),
      );
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
  
  @override
  Future<void> clearCart() async {
    try {
      await dio.delete(
        '/carts/clear',
        options: Options(
          headers: {'Content-Type': 'application/json'},
          extra: {'requiredAuth': true},
        ),
      );
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
