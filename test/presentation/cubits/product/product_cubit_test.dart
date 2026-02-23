import 'package:bloc_test/bloc_test.dart';
import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/core/usecase/usecase.dart';
import 'package:e_commerce_client/domain/entity/product_view_entity.dart';
import 'package:e_commerce_client/domain/usecases/product/get_products.dart';
import 'package:e_commerce_client/presentation/cubits/product/product_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockGetProducts extends Mock implements GetProducts {}

void main() {
  late MockGetProducts mockGetProducts;
  late ProductCubit productCubit;

  const tProductViewEntityList = [
    ProductViewEntity(
      id: '1',
      name: 'test',
      description: 'description',
      initialPrice: 20.0,
      finalPrice: 15.0,
      imageUrl: 'imageUrl',
      rating: 4.5,
      reviewCount: 100,
    ),

    ProductViewEntity(
      id: '2',
      name: 'test2',
      description: 'description2',
      initialPrice: 10.0,
      finalPrice: 8.0,
      imageUrl: 'imageUrl2',
      rating: 4.0,
      reviewCount: 50,
    ),

    ProductViewEntity(
      id: '3',
      name: 'test3',
      description: 'description3',
      initialPrice: 15.0,
      finalPrice: 12.0,
      imageUrl: 'imageUrl3',
      rating: 4.2,
      reviewCount: 75,
    ),
  ];

  setUp(() {
    mockGetProducts = MockGetProducts();
    productCubit = ProductCubit(getProducts: mockGetProducts);
  });

  blocTest<ProductCubit, ProductState>(
    'should emit [ProductLoading, ProductLoaded] when get products succeeds',
    build: () {
      when(
        () => mockGetProducts(NoParams()),
      ).thenAnswer((_) async => Right(tProductViewEntityList));

      return productCubit;
    },
    act: (cubit) => cubit.loadProducts(),
    expect: () => [
      ProductLoading(),
      ProductLoaded(products: tProductViewEntityList),
    ],
    verify: (_) {
      verify(() => mockGetProducts(NoParams())).called(1);
    },
  );

  blocTest<ProductCubit, ProductState>(
    'should emit [ProductLoading, ProductFailure] when get products fails',
    build: () {
      when(
        () => mockGetProducts(NoParams()),
      ).thenAnswer((_) async => const Left(Failure('Failed to load products')));

      return productCubit;
    },
    act: (cubit) => cubit.loadProducts(),
    expect: () => [
      ProductLoading(),
      const ProductFailure(message: 'Failed to load products'),
    ],
    verify: (_) {
      verify(() => mockGetProducts(NoParams())).called(1);
    },
  );
}
