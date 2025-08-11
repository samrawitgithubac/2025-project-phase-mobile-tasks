import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/features/products/doamin/entities/product.dart';
import 'package:ecommerce_app/features/products/doamin/repositories/product_repository.dart';
import 'package:ecommerce_app/features/products/doamin/usecases/create_new_product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import './create_new_product_test.mocks.dart';


@GenerateMocks([ProductRepository])

void main() {
  late MockProductRepository mockProductRepository;
  late CreateProductUsecase createProductUsecase;
  setUp(() {
    mockProductRepository = MockProductRepository();
    createProductUsecase = CreateProductUsecase(mockProductRepository);
  });
  const tProduct = Product(
      id: '1',
      name: 'Prod 1',
      description: 'Desc 1',
      imageUrl: 'url1',
      price: 10.0);
  test('Should create a new product', () async {
    //arrange
    when(mockProductRepository.createProduct(tProduct))
        .thenAnswer((_) async => const Right(null));
    //act
    final result = await createProductUsecase.call(const Params(product: tProduct));
    //assert
    expect(result, const Right(null));
    verify(mockProductRepository.createProduct(tProduct));
    verifyNoMoreInteractions(mockProductRepository);
  });
}
