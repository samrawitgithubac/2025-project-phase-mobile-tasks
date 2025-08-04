import 'dart:convert';

import 'package:ecommerce_app/core/constants/api_constants.dart';
import 'package:ecommerce_app/core/error/exception.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_remote_data_source.dart';
import 'package:ecommerce_app/features/product/data/models/Product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import 'product_remote_data_source_test.mocks.dart';



@GenerateMocks([http.Client])
void main() {
  late MockClient mockHttpClient;
  late ProductRemoteDataSourceImpl dataSource;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = ProductRemoteDataSourceImpl(mockHttpClient);
  });

  const tProductModel = ProductModel(
    id: 1,
    name: 'Test',
    description: 'desc',
    imageURL: 'img.png',
    price: 99.99,
  );
  final tProductJson = tProductModel.toJson();

  group('getAllProducts', () {
    test('should return List<Product> when response code is 200', () async {
      when(mockHttpClient.get(Uri.parse(baseUrl), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(json.encode([tProductJson]), 200));

      final result = await dataSource.getAllProducts();

      expect(result, isA<List<ProductModel>>());
      verify(mockHttpClient.get(Uri.parse(baseUrl), headers: anyNamed('headers')));
    });

    test('should throw ServerException on non-200 response', () async {
      when(mockHttpClient.get(Uri.parse(baseUrl), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));

      expect(() => dataSource.getAllProducts(), throwsA(isA<ServerException>()));
    });
  });

  group('getProductById', () {
    test('should return ProductModel when response code is 200', () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/1'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(json.encode(tProductJson), 200));

      final result = await dataSource.getProductById(1);

      expect(result, isA<ProductModel>());
      verify(mockHttpClient.get(Uri.parse('$baseUrl/1'), headers: anyNamed('headers')));
    });

    test('should throw ServerException on non-200 response', () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/1'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Not found', 404));

      expect(() => dataSource.getProductById(1), throwsA(isA<ServerException>()));
    });
  });

  group('createProduct', () {
    test('should complete successfully on 201/200 response', () async {
      when(mockHttpClient.post(Uri.parse(baseUrl),
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('', 201));

      await dataSource.createProduct(tProductModel);

      verify(mockHttpClient.post(Uri.parse(baseUrl),
          headers: anyNamed('headers'), body: json.encode(tProductModel.toJson())));
    });

    test('should throw ServerException on failure', () async {
      when(mockHttpClient.post(Uri.parse(baseUrl),
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('Bad Request', 400));

      expect(() => dataSource.createProduct(tProductModel), throwsA(isA<ServerException>()));
    });
  });

  group('updateProduct', () {
    test('should complete successfully on 200/204 response', () async {
      when(mockHttpClient.put(Uri.parse('$baseUrl/1'),
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('', 200));

      await dataSource.updateProduct(tProductModel);

      verify(mockHttpClient.put(Uri.parse('$baseUrl/1'),
          headers: anyNamed('headers'), body: json.encode(tProductModel.toJson())));
    });

    test('should throw ServerException on failure', () async {
      when(mockHttpClient.put(Uri.parse('$baseUrl/1'),
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('Error', 500));

      expect(() => dataSource.updateProduct(tProductModel), throwsA(isA<ServerException>()));
    });
  });

  group('deleteProduct', () {
    test('should complete successfully on 200/204 response', () async {
      when(mockHttpClient.delete(Uri.parse('$baseUrl/1'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('', 204));

      await dataSource.deleteProduct(1);

      verify(mockHttpClient.delete(Uri.parse('$baseUrl/1'), headers: anyNamed('headers')));
    });

    test('should throw ServerException on failure', () async {
      when(mockHttpClient.delete(Uri.parse('$baseUrl/1'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Not allowed', 403));

      expect(() => dataSource.deleteProduct(1), throwsA(isA<ServerException>()));
    });
  });
}
