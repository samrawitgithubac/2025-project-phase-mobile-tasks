import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/core/platform/network_info.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_remote_data_source.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_local_data_source.dart';
import 'package:ecommerce_app/features/product/data/models/Product_model.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:ecommerce_app/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl extends ProductRepository {
  final ProductRemoteDataSource remoteDatasource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  ProductRepositoryImpl(
    this.remoteDatasource,
    this.localDataSource,
    this.networkInfo,
  );

  @override
  Future<Either<Failure, void>> createProduct(Product product) async {
    // return const Right(null);
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.createProduct(ProductModel.fromEntity(product));
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(Product product) async {
    // return const Right(null);
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.updateProduct(ProductModel.fromEntity(product));
        return Right(null);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(int id) async {
    // return const Right(null);
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.deleteProduct(id);
        return Right(null);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    // return const Right([]);
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.getAllProducts();
        localDataSource.cacheProducts(
          result.map((product) => ProductModel.fromEntity(product)).toList(),
        );
        return Right(result);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      try {
        final cacheResult = await localDataSource.getAllProducts();
        // return Right(cacheResult);
        return Right(cacheResult.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(int id) async {
    // return Right(Product(id: id, name: 'name', description: 'description', imageURL: 'imageURL', price: 10));
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.getProductById(id);
        return Right(result);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      try {
        final result = await localDataSource.getProductById(id);
        return Right(result);
      } catch (e) {
        return Left(CacheFailure());
      }
    }
  }
}
