import '../../../domain/usecases/product/get_products.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/usecase/usecase.dart';
import '../../../domain/entity/product_view_entity.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProducts _getProducts;

  ProductCubit({required GetProducts getProducts})
    : _getProducts = getProducts,
      super(ProductInitial());

  Future<void> loadProducts() async {
    emit(const ProductLoading());
    final result = await _getProducts(NoParams());
    result.fold(
      (failure) => emit(ProductFailure(message: failure.message)),
      (products) => emit(ProductLoaded(products: products)),
    );
  }
}
