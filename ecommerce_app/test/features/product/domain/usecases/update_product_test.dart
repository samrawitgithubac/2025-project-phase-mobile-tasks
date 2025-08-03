import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:ecommerce_app/features/product/domain/repositories/product_repository.dart';

import 'package:ecommerce_app/features/product/domain/usecases/update_product_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'update_product_test.mocks.dart';
// import 'create_product_test_mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late MockProductRepository repository;
  late UpdateProductUseCase usecase;

  setUp(() {
    repository = MockProductRepository();
    usecase = UpdateProductUseCase(repository);
  });
  test('update a product by the id', ()async{
    //arrange
    // const testId=1;
    const product=Product(
      id: 1, 
      name: 'name', 
      description: 'description', 
      imageURL: 'imageURL', 
      price: 12.00);

    when(repository.updateProduct(product)).thenAnswer((_) async => const Right(null));
    //act
    final result= await usecase(product);
    //assert
    expect(result,const Right(null));
    verify(repository.updateProduct(product)).called(1);
    verifyNoMoreInteractions(repository);

  });
}