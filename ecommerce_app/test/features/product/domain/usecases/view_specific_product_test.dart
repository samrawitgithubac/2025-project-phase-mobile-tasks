import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:ecommerce_app/features/product/domain/repositories/product_repository.dart';

import 'package:ecommerce_app/features/product/domain/usecases/view_specific_product_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'view_specific_product_test.mocks.dart';
// import 'view_specific_product_test_mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late MockProductRepository repository;
  late ViewSpecificProductUseCase usecase;

  setUp(() {
    repository = MockProductRepository();
    usecase = ViewSpecificProductUseCase(repository);
  });
  test('return a product by its id', ()async {
    //arrange
    const testId=1;
    const product=Product(
      id: testId, 
      name: 'name', 
      description: 'description',
      imageURL: 'imageURL', 
      price: 12.00);
    when(repository.getProductById(testId)).thenAnswer((_)async =>const Right(product));
    //act
    final result=await usecase( testId);
    //assert
    expect(result, const Right(product));
    verify(repository.getProductById(testId)).called(1);
    verifyNoMoreInteractions(repository);
  });

}