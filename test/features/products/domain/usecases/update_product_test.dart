import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/features/products/doamin/entities/product.dart';

import 'package:ecommerce_app/features/products/doamin/usecases/update_product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'create_new_product_test.mocks.dart' show MockProductRepository;


void main() {
  late MockProductRepository mockProductRepository;
  late UpdateProductUsecase updateProductUsecase;
  setUp(() {
    mockProductRepository = MockProductRepository();
    updateProductUsecase = UpdateProductUsecase(mockProductRepository);
  });

  const tProduct = Product(
      id: '1',
      name: 'Prod 1',
      description: 'Desc 1',
      imageUrl: 'url1',
      price: 10.0);
  test('Should update existing product', () async {
    //arrange
    when(mockProductRepository.updateProduct(tProduct))
        .thenAnswer((_) async => const Right(null));
    //act
    final result = await updateProductUsecase.call(const Params(product: tProduct));
    //assert
    expect(result, const Right(null));
    verify(mockProductRepository.updateProduct(tProduct));
    verifyNoMoreInteractions(mockProductRepository);
  });
}
