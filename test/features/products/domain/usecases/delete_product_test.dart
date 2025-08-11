import 'package:dartz/dartz.dart';


import 'package:ecommerce_app/features/products/doamin/usecases/delete_product.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';

import 'create_new_product_test.mocks.dart';




void main() {
  late MockProductRepository mockProductRepository;
  late DeleteProductUsecase deleteProductUsecase;
  setUp(() {
    mockProductRepository = MockProductRepository();
    deleteProductUsecase = DeleteProductUsecase(mockProductRepository);
  });

  test('Should delete the product at the given id', () async {
    //arrnage
    when(mockProductRepository.deleteProduct('1'))
        .thenAnswer((_) async => const Right(null));
    //act
    final result =await  deleteProductUsecase.call(const Params(id: '1'));
    //assert
    expect(result, const Right(null));
    verify(mockProductRepository.deleteProduct('1'));
    verifyNoMoreInteractions(mockProductRepository);
  });
}
