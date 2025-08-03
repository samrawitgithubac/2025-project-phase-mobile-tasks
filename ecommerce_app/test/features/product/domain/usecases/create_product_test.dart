import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:ecommerce_app/features/product/domain/repositories/product_repository.dart';
import 'package:ecommerce_app/features/product/domain/usecases/create_product_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'create_product_test.mocks.dart';
// import 'create_product_test_mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late MockProductRepository repository;
  late CreateProductUseCase usecase;

  setUp(() {
    repository = MockProductRepository();
    usecase = CreateProductUseCase(repository);
  });

  test(
    'should call repository to create a product and return Right(null) on success',
    () async {
      // arrange
      const product = Product(
        id: 1,
        name: 'test product',
        description: 'product description',
        imageURL: 'imageURL',
        price: 10.00,
      );

      when(repository.createProduct(product)).thenAnswer((_) async => const Right(null));

      // act
      final result = await usecase(product);

      // assert
      expect(result, const Right(null));
      verify(repository.createProduct(product)).called(1); 
      verifyNoMoreInteractions(repository);
    },
  );
}
