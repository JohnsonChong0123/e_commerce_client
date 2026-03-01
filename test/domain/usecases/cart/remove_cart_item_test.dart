import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/domain/repositories/cart_repository.dart';
import 'package:e_commerce_client/domain/usecases/cart/remove_cart_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late CartRepository mockRepository;
  late RemoveCartItem usecase;

  const tParams = RemoveCartItemParams(productId: 'B09NQJFRW6');

  setUp(() {
    mockRepository = MockCartRepository();
    usecase = RemoveCartItem(mockRepository);
  });

  test(
    'should call repository removeCartItem and return Unit on success',
    () async {
      // arrange
      when(
        () => mockRepository.removeCartItem(tParams.productId),
      ).thenAnswer((_) async => const Right(unit));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, equals(const Right(unit)));
      verify(
        () => mockRepository.removeCartItem(tParams.productId),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return Failure when repository returns Failure', () async {
    // arrange
    const failure = Failure('Cache or Server error');

    when(
      () => mockRepository.removeCartItem(tParams.productId),
    ).thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase(tParams);

    // assert
    expect(result, const Left(failure));
    verify(
      () => mockRepository.removeCartItem(tParams.productId),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
