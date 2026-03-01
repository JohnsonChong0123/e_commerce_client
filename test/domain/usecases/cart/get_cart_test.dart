import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/core/usecase/usecase.dart';
import 'package:e_commerce_client/domain/entity/cart_entity.dart';
import 'package:e_commerce_client/domain/entity/cart_item_entity.dart';
import 'package:e_commerce_client/domain/repositories/cart_repository.dart';
import 'package:e_commerce_client/domain/usecases/cart/get_cart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late CartRepository mockRepository;
  late GetCart usecase;

  const tCartEntity = CartEntity(
    id: '1d3ed0a0-b460-4137-81b6-7e4befc3b63b',
    items: [
      CartItemEntity(
        productId: 'B09NQJFRW6',
        name: 'Saucony Men\'s Kinvara 13 Running Shoe',
        price: 57.79,
        quantity: 3,
        imageUrl: 'https://m.media-amazon.com/images/I/71QeGmahUnL._AC_UX500_.jpg'
      ),
      CartItemEntity(
        productId: 'B0CY242B8P',
        name: '4th of July Door Sign Independence Day Wreath Patriotic Door Decoration Flower US Wooden Sign for Memorial Day Front for Door Decor 12 Inch Outdoor',
        price: 7.99,
        quantity: 3,
        imageUrl: 'https://m.media-amazon.com/images/I/81BvLYGKcuL._AC_SL1500_.jpg'
      ),
    ],
    cartTotal: 197.34,
  );

  setUp(() {
    mockRepository = MockCartRepository();
    usecase = GetCart(mockRepository);
  });

  test(
    'should call repository getCart and return CartEntity on success',
    () async {
      // arrange
      when(
        () => mockRepository.getCart(),
      ).thenAnswer((_) async => const Right(tCartEntity));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, equals(const Right(tCartEntity)));
      verify(() => mockRepository.getCart()).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return Failure when repository returns Failure', () async {
    // arrange
    const failure = Failure('Cache or Server error');

    when(
      () => mockRepository.getCart(),
    ).thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, const Left(failure));
    verify(() => mockRepository.getCart()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
