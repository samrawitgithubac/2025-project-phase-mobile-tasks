import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/exception.dart';
import 'package:ecommerce_app/core/error/failures.dart';
import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/features/products/data/datasources/product_local_datasource.dart';
import 'package:ecommerce_app/features/products/data/datasources/product_remote_datasource.dart';
import 'package:ecommerce_app/features/products/data/models/product_model.dart';
import 'package:ecommerce_app/features/products/data/repository/product_repository_impl.dart';
import 'package:ecommerce_app/features/products/doamin/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import './product_repository_impl_test.mocks.dart';

@GenerateMocks([ProductLocalDatasource, ProductRemoteDatasource, NetworkInfo])
void main() {
  late ProductRepositoryImpl repositoryImpl;
  late MockProductLocalDatasource mockProductLocalDataSource;
  late MockProductRemoteDatasource mockProuctRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockProuctRemoteDataSource = MockProductRemoteDatasource();
    mockProductLocalDataSource = MockProductLocalDatasource();
    repositoryImpl = ProductRepositoryImpl(
        localDatasource: mockProductLocalDataSource,
        remoteDatasource: mockProuctRemoteDataSource,
        networkInfo: mockNetworkInfo);
  });

  const tProductModel = ProductModel(
      id: '1',
      name: 'test',
      price: 20.0,
      description: 'test product',
      imageUrl: 'test/test_image');

  group('Device online test', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    //get all product online test
    test('Should return list of all products from remote source', () async {
      // Arrange
      when(mockProuctRemoteDataSource.getAllProducts())
          .thenAnswer((_) async => [tProductModel]);

      // Act
      final result = await repositoryImpl.getAllProducts();

      // Assert
      expect(result, isA<Right>());

      // Then, extract the value from the Right and compare it
      result.fold(
        (failure) => fail('Expected Right, but got Left with $failure'),
        (products) {
          expect(products, [tProductModel]);
        },
      );

      verify(mockProuctRemoteDataSource.getAllProducts());
    });

    // get product online test
    test('Should return a single product from remote source', () async {
      // Arrange
      when(mockProuctRemoteDataSource.getProductById(tProductModel.id))
          .thenAnswer((_) async => tProductModel);

      // Act
      final result = await repositoryImpl.getProductById(tProductModel.id);

      // Assert
      expect(result, isA<Right>());

      result.fold(
        (failure) => fail('Expected Right, but got Left: $failure'),
        (product) => expect(product, tProductModel),
      );
    });
    //create product online test

    test('Should delete product from remote data source', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockProuctRemoteDataSource.deleteProduct(any))
          .thenAnswer((_) async => Future.value());

      // Act
      await repositoryImpl.deleteProduct(tProductModel.id);

      // Assert
      verify(mockProuctRemoteDataSource.deleteProduct(tProductModel.id))
          .called(1);
      verifyNoMoreInteractions(mockProuctRemoteDataSource);
    });

    //update product online test
    test('Should update product', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockProuctRemoteDataSource.updateProduct(any))
          .thenAnswer((_) async => Future.value());

      // Act
      await repositoryImpl.updateProduct(tProductModel);

      // Assert
      verify(mockProuctRemoteDataSource.updateProduct(tProductModel)).called(1);
      verifyNoMoreInteractions(mockProuctRemoteDataSource);
    });

//create product online test
    test('Should create product', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockProuctRemoteDataSource.createProduct(any))
          .thenAnswer((_) async => Future.value());

      // Act
      await repositoryImpl.createProduct(tProductModel);

      // Assert
      verify(mockProuctRemoteDataSource.createProduct(tProductModel)).called(1);
      verifyNoMoreInteractions(mockProuctRemoteDataSource);
    });

    test('Should check to see catching of a single product happen', () async {
      when(mockProuctRemoteDataSource.getProductById(tProductModel.id))
          .thenAnswer((_) async => tProductModel);
      await repositoryImpl.getProductById(tProductModel.id);
      verify(mockProuctRemoteDataSource.getProductById(tProductModel.id))
          .called(1);

      verify(mockProductLocalDataSource.cacheProduct(tProductModel)).called(1);
    });
  });

  group('device offline', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });
    test('Should return list of all products from cached source when offline',
        () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockProductLocalDataSource.getProducts())
          .thenAnswer((_) async => [tProductModel]);

      final List<Product> tProductList = [tProductModel];

      // Act
      final result = await repositoryImpl.getAllProducts();

      // Assert
      verifyZeroInteractions(mockProuctRemoteDataSource);
      verify(mockProductLocalDataSource.getProducts()).called(1);

      expect(result, isA<Right<Failure, List<Product>>>());

      result.fold(
        (failure) => fail('Expected Right, but got Left with $failure'),
        (products) => expect(products, tProductList),
      );
    });
    test('Should return product from cached source when offline', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockProductLocalDataSource.getProduct())
          .thenAnswer((_) async => tProductModel);

      // Act
      final result = await repositoryImpl.getProductById('9');

      // Assert
      verifyZeroInteractions(mockProuctRemoteDataSource);
      verify(mockProductLocalDataSource.getProduct()).called(1);

      expect(result, isA<Right<Failure, Product>>());

      result.fold(
        (failure) => fail('Expected Right, but got Left with $failure'),
        (product) => expect(product, tProductModel),
      );
    });

    test(
      'Should return cache failure when there is no cached data',
      () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(mockProductLocalDataSource.getProducts())
            .thenThrow(CacheException());

        // Act
        final result = await repositoryImpl.getAllProducts();

        // Assert
        verifyZeroInteractions(mockProuctRemoteDataSource);
        verify(mockProductLocalDataSource.getProducts()).called(1);
        expect(result, equals(Left(CacheFailure())));
      },
    );
test(
      'Should return cache failure when there is no cached product data',
      () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(mockProductLocalDataSource.getProduct())
            .thenThrow(CacheException());

        // Act
        final result = await repositoryImpl
            .getProductById('id'); 

        // Assert
        verifyZeroInteractions(mockProuctRemoteDataSource);

        verify(mockProductLocalDataSource.getProduct()).called(1);
        expect(result, equals(Left(CacheFailure())));
      },
    );



  });
}
