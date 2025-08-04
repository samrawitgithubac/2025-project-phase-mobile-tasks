import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/exception.dart';
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/core/network/network_info.dart';
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
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.createProduct(ProductModel.fromEntity(product));
        return const Right(null);
      } on ServerException {
        return const Left(ServerFailure("Server Exception"));
      } catch (_) {
        return const Left(ServerFailure("Unknown server error"));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(Product product) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.updateProduct(ProductModel.fromEntity(product));
        return const Right(null);
      } on ServerException {
        return const Left(ServerFailure("Server Exception"));
      } catch (_) {
        return const Left(ServerFailure("Unknown server error"));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(int id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.deleteProduct(id);
        return const Right(null);
      } on ServerException {
        return const Left(ServerFailure("Server Exception"));
      } catch (_) {
        return const Left(ServerFailure("Unknown server error"));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProducts = await remoteDatasource.getAllProducts();
        await localDataSource.cacheProducts(remoteProducts);
        return Right(remoteProducts.map((model) => model.toEntity()).toList());
      } on ServerException {
        return const Left(ServerFailure("Server Exception"));
      } catch (_) {
        return const Left(ServerFailure("Unknown server error"));
      }
    } else {
      try {
        final cachedProducts = await localDataSource.getAllProducts();
        return Right(cachedProducts.map((model) => model.toEntity()).toList());
      } on CacheException {
        return const Left(CacheFailure("Cache Exception"));
      } catch (_) {
        return const Left(CacheFailure("Unknown cache error"));
      }
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProduct = await remoteDatasource.getProductById(id);
        return Right(remoteProduct.toEntity());
      } on ServerException {
        return const Left(ServerFailure("Server Exception"));
      } catch (_) {
        return const Left(ServerFailure("Unknown server error"));
      }
    } else {
      try {
        final cachedProduct = await localDataSource.getProductById(id);
        return Right(cachedProduct.toEntity());
      } on CacheException {
        return const Left(CacheFailure("Cache Exception"));
      } catch (_) {
        return const Left(CacheFailure("Unknown cache error"));
      }
    }
  }
}
