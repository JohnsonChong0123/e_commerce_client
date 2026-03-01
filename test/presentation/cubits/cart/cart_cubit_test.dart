import 'package:bloc_test/bloc_test.dart';
import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/core/usecase/usecase.dart';
import 'package:e_commerce_client/domain/entity/cart_entity.dart';
import 'package:e_commerce_client/domain/entity/cart_item_entity.dart';
import 'package:e_commerce_client/domain/usecases/cart/add_to_cart.dart';
import 'package:e_commerce_client/domain/usecases/cart/clear_cart.dart';
import 'package:e_commerce_client/domain/usecases/cart/get_cart.dart';
import 'package:e_commerce_client/domain/usecases/cart/remove_cart_item.dart';
import 'package:e_commerce_client/presentation/cubits/cart/cart_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAddToCart extends Mock implements AddToCart {}

class MockGetCart extends Mock implements GetCart {}

class MockRemoveCartItem extends Mock implements RemoveCartItem {}

class MockClearCart extends Mock implements ClearCart {}

void main() {
  late MockAddToCart mockAddToCart;
  late MockGetCart mockGetCart;
  late MockRemoveCartItem mockRemoveCartItem;
  late MockClearCart mockClearCart;
  late CartCubit cartCubit;

  const tParams = AddToCartParams(productId: '1', quantity: 2);

  const productId = '1';
  const quantity = 2;

  const tCartEntity = CartEntity(
    id: '1d3ed0a0-b460-4137-81b6-7e4befc3b63b',
    items: [
      CartItemEntity(
        productId: 'B09NQJFRW6',
        name: 'Saucony Men\'s Kinvara 13 Running Shoe',
        price: 57.79,
        quantity: 3,
        imageUrl:
            'https://m.media-amazon.com/images/I/71QeGmahUnL._AC_UX500_.jpg',
      ),
      CartItemEntity(
        productId: 'B0CY242B8P',
        name:
            '4th of July Door Sign Independence Day Wreath Patriotic Door Decoration Flower US Wooden Sign for Memorial Day Front for Door Decor 12 Inch Outdoor',
        price: 7.99,
        quantity: 3,
        imageUrl:
            'https://m.media-amazon.com/images/I/81BvLYGKcuL._AC_SL1500_.jpg',
      ),
    ],
    cartTotal: 197.34,
  );

  setUp(() {
    mockAddToCart = MockAddToCart();
    mockGetCart = MockGetCart();
    mockRemoveCartItem = MockRemoveCartItem();
    mockClearCart = MockClearCart();
    cartCubit = CartCubit(
      addToCart: mockAddToCart,
      getCart: mockGetCart,
      removeCartItem: mockRemoveCartItem,
      clearCart: mockClearCart,
    );
  });

  group('CartCubit AddToCart', () {
    blocTest<CartCubit, CartState>(
      'should emit [CartLoading, CartSuccess] when add to cart succeeds',
      build: () {
        when(
          () => mockAddToCart(tParams),
        ).thenAnswer((_) async => const Right(unit));
        return cartCubit;
      },
      act: (cubit) => cubit.addToCart(productId: productId, quantity: quantity),
      expect: () => [CartLoading(), CartSuccess()],
      verify: (_) {
        verify(() => mockAddToCart(tParams)).called(1);
      },
    );

    blocTest<CartCubit, CartState>(
      'should emit [CartLoading, CartFailure] when add to cart fails',
      build: () {
        when(
          () => mockAddToCart(tParams),
        ).thenAnswer((_) async => const Left(Failure('Failed to add to cart')));

        return cartCubit;
      },
      act: (cubit) => cubit.addToCart(productId: productId, quantity: quantity),
      expect: () => [
        CartLoading(),
        const CartFailure(message: 'Failed to add to cart'),
      ],
      verify: (_) {
        verify(() => mockAddToCart(tParams)).called(1);
      },
    );
  });

  group('CartCubit GetCart', () {
    blocTest<CartCubit, CartState>(
      'should emit [CartLoading, CartSuccess] when get cart succeeds',
      build: () {
        when(
          () => mockGetCart(NoParams()),
        ).thenAnswer((_) async => const Right(tCartEntity));
        return cartCubit;
      },
      act: (cubit) => cubit.getCart(),
      expect: () => [CartLoading(), CartLoaded(carts: tCartEntity)],
      verify: (_) {
        verify(() => mockGetCart(NoParams())).called(1);
      },
    );

    blocTest<CartCubit, CartState>(
      'should emit [CartLoading, CartFailure] when get cart fails',
      build: () {
        when(
          () => mockGetCart(NoParams()),
        ).thenAnswer((_) async => const Left(Failure('Failed to get cart')));

        return cartCubit;
      },
      act: (cubit) => cubit.getCart(),
      expect: () => [
        CartLoading(),
        const CartFailure(message: 'Failed to get cart'),
      ],
      verify: (_) {
        verify(() => mockGetCart(NoParams())).called(1);
      },
    );
  });

  group('CartCubit RemoveCartItem', () {
    blocTest<CartCubit, CartState>(
      'should emit [CartLoading, CartSuccess] when remove cart item succeeds',
      build: () {
        when(
          () => mockRemoveCartItem(RemoveCartItemParams(productId: productId)),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockGetCart(NoParams()),
        ).thenAnswer((_) async => Right(tCartEntity));
        return cartCubit;
      },
      act: (cubit) => cubit.removeCartItem(productId),
      expect: () => [CartLoading(), CartLoaded(carts: tCartEntity)],
      verify: (_) {
        verify(
          () => mockRemoveCartItem(RemoveCartItemParams(productId: productId)),
        ).called(1);

        verify(() => mockGetCart(NoParams())).called(1);
      },
    );

    blocTest<CartCubit, CartState>(
      'should emit [CartLoading, CartFailure] when remove cart item fails',
      build: () {
        when(
          () => mockRemoveCartItem(RemoveCartItemParams(productId: productId)),
        ).thenAnswer(
          (_) async => const Left(Failure('Failed to remove cart item')),
        );

        return cartCubit;
      },
      act: (cubit) => cubit.removeCartItem(productId),
      expect: () => [
        CartLoading(),
        const CartFailure(message: 'Failed to remove cart item'),
      ],
      verify: (_) {
        verify(
          () => mockRemoveCartItem(RemoveCartItemParams(productId: productId)),
        ).called(1);
        verifyNever(() => mockGetCart(NoParams()));
      },
    );
  });

  group('CartCubit ClearCart', () {
    blocTest<CartCubit, CartState>(
      'should emit [CartLoading, CartSuccess] when clear cart succeeds',
      build: () {
        when(
          () => mockClearCart(NoParams()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockGetCart(NoParams()),
        ).thenAnswer((_) async => Right(tCartEntity));
        return cartCubit;
      },
      act: (cubit) => cubit.clearCart(),
      expect: () => [CartLoading(), CartLoaded(carts: tCartEntity)],
      verify: (_) {
        verify(() => mockClearCart(NoParams())).called(1);
        verify(() => mockGetCart(NoParams())).called(1);
      },
    );

    blocTest<CartCubit, CartState>(
      'should emit [CartLoading, CartFailure] when clear cart fails',
      build: () {
        when(
          () => mockClearCart(NoParams()),
        ).thenAnswer((_) async => const Left(Failure('Failed to clear cart')));
        return cartCubit;
      },
      act: (cubit) => cubit.clearCart(),
      expect: () => [
        CartLoading(),
        const CartFailure(message: 'Failed to clear cart'),
      ],
      verify: (_) {
        verify(() => mockClearCart(NoParams())).called(1);
        verifyNever(() => mockGetCart(NoParams()));
      },
    );
  });
}
