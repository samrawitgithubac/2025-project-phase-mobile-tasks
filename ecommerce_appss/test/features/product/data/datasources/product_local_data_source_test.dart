import 'dart:convert';

import 'package:ecommerce_app/core/error/exception.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_local_data_source.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce_app/features/product/data/models/Product_model.dart';

import 'product_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late ProductLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = ProductLocalDataSourceImpl(mockSharedPreferences);
  });

  const testProducts = [
    ProductModel(id: 1, name: 'Test', description: 'desc', imageURL: 'img', price: 99.99),
    ProductModel(id: 2, name: 'Another', description: 'desc2', imageURL: 'img2', price: 49.99),
  ];

  final cachedList = testProducts.map((e) => jsonEncode(e.toJson())).toList();

  group('cacheProducts', () {
    test('should call sharedPreferences to save a list of products', () async {
      // Arrange: stub setStringList to return true
      when(mockSharedPreferences.setStringList(any, any))
          .thenAnswer((_) async => true);

      // Act
      await dataSource.cacheProducts(testProducts);

      // Assert
      verify(mockSharedPreferences.setStringList('CACHED_PRODUCTS', cachedList));
    });
  });

  group('getAllProducts', () {
    test('should return list of product models from sharedPreferences', () async {
      // Arrange
      when(mockSharedPreferences.getStringList(any)).thenReturn(cachedList);

      // Act
      final result = await dataSource.getAllProducts();

      // Assert
      expect(result, equals(testProducts));
    });

    test('should throw CacheException when no data found', () async {
      // Arrange
      when(mockSharedPreferences.getStringList(any)).thenReturn(null);

      // Assert
      expect(() => dataSource.getAllProducts(), throwsA(isA<CacheException>()));
    });
  });

  group('getProductById', () {
    test('should return the correct ProductModel by id', () async {
      // Arrange
      when(mockSharedPreferences.getStringList(any)).thenReturn(cachedList);

      // Act
      final result = await dataSource.getProductById(1);

      // Assert
      expect(result, equals(testProducts[0]));
    });

    test('should throw CacheException if id is not found', () async {
      // Arrange
      when(mockSharedPreferences.getStringList(any)).thenReturn(cachedList);

      // Assert
      expect(() => dataSource.getProductById(999), throwsA(isA<CacheException>()));
    });

    test('should throw CacheException when cache is null', () async {
      // Arrange
      when(mockSharedPreferences.getStringList(any)).thenReturn(null);

      // Assert
      expect(() => dataSource.getProductById(999), throwsA(isA<CacheException>()));
    });
  });
}
