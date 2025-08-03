import 'package:dartz/dartz.dart';
// import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:ecommerce_app/features/product/domain/repositories/product_repository.dart';
// import 'package:ecommerce_app/features/product/domain/usecases/create_product_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecases/delete_product_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// import 'create_product_test.mocks.dart';
import 'delete_product_test.mocks.dart';
// import 'delete_product_test_mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late MockProductRepository repository;
  late DeleteProductUseCase usecase;

  setUp(() {
    repository = MockProductRepository();
    usecase = DeleteProductUseCase(repository);
  });
  test('should delete product with correct id', () async {
    //arrange
    const testId=1;
    
    when(repository.deleteProduct(testId)).thenAnswer((_)async=>const Right(null));
    //act
    final result= await usecase( testId);
    //assert
    expect(result, const Right(null));
    
    verify(repository.deleteProduct(testId)).called(1); 
    verifyNoMoreInteractions(repository);
  });
  }