import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/core/usecase/usecase.dart';
import 'package:e_commerce_client/domain/repositories/cart_repository.dart';
import 'package:e_commerce_client/domain/usecases/cart/clear_cart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late CartRepository mockRepository;
  late ClearCart usecase;

  setUp(() {
    mockRepository = MockCartRepository();
    usecase = ClearCart(mockRepository);
  });

  test('should call repository clearCart and return Unit on success', () async {
    // arrange
    when(
      () => mockRepository.clearCart(),
    ).thenAnswer((_) async => const Right(unit));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, equals(const Right(unit)));
    verify(() => mockRepository.clearCart()).called(1);
  });

  test('should return Failure when repository returns Failure', () async {
    // arrange
    const failure = Failure('Cache or Server error');

    when(
      () => mockRepository.clearCart(),
    ).thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, const Left(failure));
    verify(() => mockRepository.clearCart()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
