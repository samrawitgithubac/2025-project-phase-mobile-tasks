import 'package:dartz/dartz.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../doamin/entities/product.dart';
import '../../doamin/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDatasource localDatasource;
  final ProductRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> createProduct(Product product) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDatasource.createProduct(product));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDatasource.deleteProduct(id));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    if (await networkInfo.isConnected) {
      try {
        final productList = await remoteDatasource.getAllProducts();
        await localDatasource.cacheProducts(productList);
        return Right(productList);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        return Right(await localDatasource.getProducts());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final product = await remoteDatasource.getProductById(id);
        await localDatasource.cacheProduct(product);
        return Right(product);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        return Right(await localDatasource.getProduct());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(Product product) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDatasource.updateProduct(product));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }
}
