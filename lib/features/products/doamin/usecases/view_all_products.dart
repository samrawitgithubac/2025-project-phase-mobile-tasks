import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';


class ViewAllProductsUsecase extends Usecase<List<Product>,NoParams>{
 final  ProductRepository repository;
  ViewAllProductsUsecase(this.repository);
  @override
  Future<Either<Failure,List<Product>>> call(NoParams params)async {
    return await repository.getAllProducts();
  }
}
