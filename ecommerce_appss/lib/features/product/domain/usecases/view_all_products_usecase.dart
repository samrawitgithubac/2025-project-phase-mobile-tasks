import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';
import 'usecase.dart';

class ViewAllProductsUseCase extends Usecase<List<Product>,NoParams> {
  final ProductRepository repository;
  ViewAllProductsUseCase(this.repository);

  @override
  Future<Either<Failure,List<Product>>> call(NoParams params){
    return repository.getAllProducts();
  }



  
}