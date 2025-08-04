import 'package:dartz/dartz.dart';
// import 'package:ecommerce_app/domain/usecases/view_all_products.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:ecommerce_app/features/product/domain/repositories/product_repository.dart';
// import 'package:ecommerce_app/features/product/domain/usecases/create_product_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecases/usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecases/view_all_products_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'view_all_products_test.mocks.dart';
// import 'view_specific_product_test_mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late MockProductRepository repository;
  late ViewAllProductsUseCase usecase;

  setUp(() {
    repository = MockProductRepository();
    usecase = ViewAllProductsUseCase(repository);
  });
  test('should return list of products', () async {
    //arrange
    const products = [
      Product(
        id: 1,
        name: 'Test Product 1',
        description: 'Desc 1',
        imageURL: 'image1.jpg',
        price: 10.0,
      ),
      Product(
        id: 2,
        name: 'Test Product 2',
        description: 'Desc 2',
        imageURL: 'image2.jpg',
        price: 20.0,
      ),
    ];
    
    when(repository.getAllProducts()).thenAnswer((_) async => const Right(products));

    
    
    //act
    final result=  await usecase(NoParams());
    //assert
    expect(result, const Right(products));
    verify(repository.getAllProducts()).called(1);
    verifyNoMoreInteractions(repository);
  });

}