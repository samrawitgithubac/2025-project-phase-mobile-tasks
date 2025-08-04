import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';
import 'usecase.dart';

class CreateProductUseCase extends Usecase<void,Product> {
  final ProductRepository repository;
  CreateProductUseCase(this.repository);

  @override
  Future<Either<Failure,void>> call(Product product){
    return repository.createProduct(product);
  }
}