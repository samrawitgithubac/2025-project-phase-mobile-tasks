import 'dart:convert';

import 'package:ecommerce_app/core/error/exception.dart';
import 'package:ecommerce_app/features/products/data/datasources/product_local_datasource.dart';
import 'package:ecommerce_app/features/products/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import './product_local_datasource_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late MockSharedPreferences mocksharedPreferences;
  late ProductLocalDatasourceImp datasourceImp;
  setUp(() {
    mocksharedPreferences = MockSharedPreferences();
    datasourceImp = ProductLocalDatasourceImp(mocksharedPreferences);
  });
  final cacheKey = 'CACHED FILE';
  group('geting cached data', () {
    test('should get cached product from catche when it exists', () async {
      when(mocksharedPreferences.getString(cacheKey))
          .thenReturn(fixture('product.json'));

      final result = await datasourceImp.getProduct();
      expect(
          result, ProductModel.fromJson(jsonDecode(fixture('product.json'))));

      verify(mocksharedPreferences.getString(cacheKey));
    });

    test('should get cached list of products from cache when it exists',
        () async {
      when(mocksharedPreferences.getStringList(cacheKey))
          .thenReturn([fixture('product.json')]);
      final result = await datasourceImp.getProducts();
      expect(
        result,
        [ProductModel.fromJson(jsonDecode(fixture('product.json')))],
      );
      verify(mocksharedPreferences.getStringList(cacheKey));
    });

    test('should return cache exception when there are no products cached ',
        () async {
      // Arrange
      when(mocksharedPreferences.getStringList(cacheKey)).thenReturn(null);

      expect(
        () async => await datasourceImp.getProducts(),
        throwsA(isA<CacheException>()),
      );

      verify(mocksharedPreferences.getStringList(cacheKey));
    });

    test('should return cache exception when there is no product cached ',
        () async {
      // Arrange
      when(mocksharedPreferences.getString(cacheKey)).thenReturn(null);

      expect(
        () async => await datasourceImp.getProduct(),
        throwsA(isA<CacheException>()),
      );

      verify(mocksharedPreferences.getString(cacheKey));
    });
  });
  final tProductModel =
      ProductModel.fromJson(jsonDecode(fixture('product.json')));
  group('caching data', () {
   test('should cache single product using shared preference', () async {
      final expectedJson = jsonEncode(tProductModel.toJson());

      when(mocksharedPreferences.setString(cacheKey, expectedJson))
          .thenAnswer((_) async => true); 

      await datasourceImp.cacheProduct(tProductModel);

      verify(mocksharedPreferences.setString(cacheKey, expectedJson));
    });

     test('should cache list of  products using shared preference', () async {
      final expectedJson =[jsonEncode(tProductModel.toJson())];

      when(mocksharedPreferences.setStringList(cacheKey, expectedJson))
          .thenAnswer((_) async => true);

      await datasourceImp.cacheProducts([tProductModel]);

      verify(mocksharedPreferences.setStringList(cacheKey, expectedJson));
    });

  });
}
