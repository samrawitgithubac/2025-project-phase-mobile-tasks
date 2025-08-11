import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/usecases/usecase.dart';
import 'package:ecommerce_app/features/products/doamin/entities/product.dart';
import 'package:ecommerce_app/features/products/doamin/usecases/view_all_products.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'create_new_product_test.mocks.dart' show MockProductRepository;



void main() {
  late MockProductRepository mockProductRepository;
  late ViewAllProductsUsecase viewAllProductsUsecase;
  setUp(() {
    mockProductRepository = MockProductRepository();
    viewAllProductsUsecase = ViewAllProductsUsecase(mockProductRepository);
  });
  const List<Product> tProducts = [
    Product(
        id: '1',
        name: 'Prod 1',
        description: 'Desc 1',
        imageUrl: 'url1',
        price: 10.0),
    Product(
        id: '2',
        name: 'Prod 2',
        description: 'Desc 2',
        imageUrl: 'url2',
        price: 20.0),
  ];
  test('Should get all product from the repository', () async {
    //arrange
    when(mockProductRepository.getAllProducts())
        .thenAnswer((_) async => const Right(tProducts));
    //act
    final result = await viewAllProductsUsecase.call(const NoParams());
    //assert
    expect(result, const Right(tProducts));
    verify(mockProductRepository.getAllProducts());
    verifyNoMoreInteractions(mockProductRepository);
  });
}
