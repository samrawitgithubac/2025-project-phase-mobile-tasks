

import 'package:dartz/dartz.dart';

// import '../../../../core/error/faliure.dart';
import '../../../../core/error/failure.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';
import 'usecase.dart';

class ViewSpecificProductUseCase extends Usecase<Product,int> {
  final ProductRepository repository;
  
  ViewSpecificProductUseCase(this.repository);
  


  @override
  Future<Either<Failure,Product>> call(int id){
    return repository.getProductById(id);
  }
}