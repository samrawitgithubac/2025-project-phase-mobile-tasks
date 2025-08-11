import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/features/products/doamin/entities/product.dart';

import 'package:ecommerce_app/features/products/doamin/usecases/view_specific_product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'create_new_product_test.mocks.dart';



void main() {
  late MockProductRepository mockProductRepository;
  late ViewProductUsecase viewProductUsecase;
  setUp(() {
    mockProductRepository = MockProductRepository();
    viewProductUsecase = ViewProductUsecase(mockProductRepository);
  });
  const tProduct = Product(
    id: '1',
    name: 'Product 1',
    description: 'Desc 1',
    imageUrl: 'url1',
    price: 10.0,
  );

  test('Should get product by id ', () async {
    
    //arrange
    when(mockProductRepository.getProductById('1'))
        .thenAnswer((_) async => const Right(tProduct));
    //act
    final result = await viewProductUsecase.call(const Params(id: '1'));
    //assert
    expect(result, const Right(tProduct));
    verify(mockProductRepository.getProductById('1'));
    verifyNoMoreInteractions(MockProductRepository());
  });
}
