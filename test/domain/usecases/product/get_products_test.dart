import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/core/usecase/usecase.dart';
import 'package:e_commerce_client/domain/entity/product_view_entity.dart';
import 'package:e_commerce_client/domain/repositories/product_repository.dart';
import 'package:e_commerce_client/domain/usecases/product/get_products.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late ProductRepository mockRepository;
  late GetProducts usecase;

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
    mockRepository = MockProductRepository();
    usecase = GetProducts(mockRepository);
  });

  test(
    'should call repository getProducts and return List<ProductViewEntity> on success',
    () async {
      // arrange
      when(
        () => mockRepository.getProducts(),
      ).thenAnswer((_) async => const Right(tProductViewEntityList));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, equals(const Right(tProductViewEntityList)));
      verify(() => mockRepository.getProducts()).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return Failure when repository returns Failure', () async {
    // arrange
    const failure = Failure('Server error');

    when(
      () => mockRepository.getProducts(),
    ).thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, const Left(failure));
    verify(() => mockRepository.getProducts()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
