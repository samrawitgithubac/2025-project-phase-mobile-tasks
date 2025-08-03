import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';
import 'usecase.dart';

class UpdateProductUseCase extends Usecase<void, Product> {
  final ProductRepository repository;
  UpdateProductUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Product product) {
    return repository.updateProduct(product);
  }
}
