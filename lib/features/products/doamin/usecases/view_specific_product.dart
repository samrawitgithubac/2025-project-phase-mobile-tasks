import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class ViewProductUsecase extends Usecase<Product, Params> {
  final ProductRepository repository;
  ViewProductUsecase(this.repository);
  @override
  Future<Either<Failure, Product>> call(Params params) async {
    return await repository.getProductById(params.id);
  }
}

class Params extends Equatable {
  final String id;
  const Params({required this.id});

  @override
  List<Object> get props => [id];
}
