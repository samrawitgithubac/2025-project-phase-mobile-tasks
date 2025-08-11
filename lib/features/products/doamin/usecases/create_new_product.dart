import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class CreateProductUsecase extends Usecase<void, Params> {
  final ProductRepository repository;
  CreateProductUsecase(this.repository);
  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await repository.createProduct(params.product);
  }
}

class Params extends Equatable {
  final Product product;
  const Params({required this.product});

  @override
  List<Object> get props => [product];
}
