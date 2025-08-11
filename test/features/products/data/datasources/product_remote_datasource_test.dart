import 'dart:convert';

import 'package:ecommerce_app/core/error/exception.dart';
import 'package:ecommerce_app/features/products/data/datasources/product_remote_datasource.dart';
import 'package:ecommerce_app/features/products/data/models/product_model.dart';
import 'package:ecommerce_app/features/products/doamin/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../../fixtures/fixture_reader.dart';
import './product_remote_datasource_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockHttpClient;
  late ProductRemoteDatasourceImp datasourceImp;
  setUp(() {
    mockHttpClient = MockClient();
    datasourceImp = ProductRemoteDatasourceImp(mockHttpClient);
  });
  const tId = '1';

  void setUpStatusCode200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('product.json'), 200));
  }

  void setUpStatusCodeNot200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  final tProductModel =
      ProductModel.fromJson(jsonDecode(fixture('product.json')));
  group('tests remote connection for get product by id ', () {
    test('should perform a GET request on a URL to get product by id',
        () async {
      // Arrange
      setUpStatusCode200();
      // Act
      await datasourceImp.getProductById(tId);

      // Assert
      verify(mockHttpClient.get(
        Uri.parse(
            'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/$tId'),
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('should return a product model when the status code is 200', () async {
      setUpStatusCode200();
      final result = await datasourceImp.getProductById(tId);
      expect(result, tProductModel);
      verify(mockHttpClient.get(
          Uri.parse(
              'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/$tId'),
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return a server error when status code is not 200', () async {
      // Arrange
      setUpStatusCodeNot200();

      // Act & Assert
      expect(
        () async => await datasourceImp.getProductById(tId),
        throwsA(isA<ServerException>()),
      );

      // Verify
      verify(mockHttpClient.get(
        Uri.parse(
            'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/$tId'),
        headers: {'Content-Type': 'application/json'},
      ));
    });
  });



   group('tests remote connection for get products method', () {
   test('should perform a GET request to get all products', () async {
      // Arrange
      final productJson = fixture('product.json');
      final productListJson =
          '[$productJson]'; 

      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(productListJson, 200));

      // Act
      await datasourceImp.getAllProducts();

      // Assert
      verify(mockHttpClient.get(
        Uri.parse(
            'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/'),
        headers: {'Content-Type': 'application/json'},
      ));
    });


    test('should return a product model list when the status code is 200',
        () async {
      // Arrange
      final productJson = fixture('product.json');
      final productListJson = '[$productJson]';

      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(productListJson, 200));

      // Act
      final result = await datasourceImp.getAllProducts();

      // Assert
      expect(result, [tProductModel]);

      verify(mockHttpClient.get(
        Uri.parse(
            'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/'),
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('should return a server error when status code is not 200', () async {
      // Arrange
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));

      // Act & Assert
      expect(
        () async => await datasourceImp.getAllProducts(),
        throwsA(isA<ServerException>()),
      );

      // Verify
      verify(mockHttpClient.get(
        Uri.parse(
            'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/'),
        headers: {'Content-Type': 'application/json'},
      ));
    });

  });
    final productJson = fixture('product.json');
  final tProduct = Product.fromJson(jsonDecode(productJson));


group('tests remote connection for update product method', () {
  test('should perform a PUT request to update a product', () async {
      // Arrange
    
      when(
        mockHttpClient.put(
          any,
          body: jsonEncode(tProduct.toJson()),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer((_) async =>
          http.Response('', 200)); 

      // Act
      await datasourceImp.updateProduct(tProduct);

      // Assert
      verify(
        mockHttpClient.put(
          Uri.parse(
              'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/${tProduct.id}'),
          body: jsonEncode(tProduct.toJson()),
          headers: {'Content-Type': 'application/json'},
        ),
      );
    });

    
    test('should return a server error when status code is not 200', () async {
      // Arrange
       when(
        mockHttpClient.put(
          any,
          body: jsonEncode(tProduct.toJson()),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer((_) async => http.Response('', 404));

      // Act & Assert
      expect(
        () async => await datasourceImp.updateProduct(tProduct),
        throwsA(isA<ServerException>()),
      );

      // Verify
       verify(
        mockHttpClient.put(
          Uri.parse(
              'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/${tProduct.id}'),
          body: jsonEncode(tProduct.toJson()),
          headers: {'Content-Type': 'application/json'},
        ),
      );
    });
  });


group('tests remote connection for create product method', () {
    test('should perform a POST request to create a product', () async {
      // Arrange
      when(
        mockHttpClient.post(
          any,
          body: jsonEncode(tProduct.toJson()),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer((_) async => http.Response('', 200));

      // Act
      await datasourceImp.createProduct(tProduct);

      // Assert
      verify(
        mockHttpClient.post(
          Uri.parse(
              'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/'),
          body: jsonEncode(tProduct.toJson()),
          headers: {'Content-Type': 'application/json'},
        ),
      );
    });

    test('should return a server error when status code is not 200', () async {
      // Arrange
      when(
        mockHttpClient.post(
          any,
          body: jsonEncode(tProduct.toJson()),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer((_) async => http.Response('', 404));

      // Act & Assert
      expect(
        () async => await datasourceImp.createProduct(tProduct),
        throwsA(isA<ServerException>()),
      );

      // Verify
      verify(
        mockHttpClient.post(
          Uri.parse(
              'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/'),
          body: jsonEncode(tProduct.toJson()),
          headers: {'Content-Type': 'application/json'},
        ),
      );
    });
  });


group('tests remote connection checker to delete a product', () {
    test('should perform a DELETE request to delete a product', () async {
      // Arrange
      when(
        mockHttpClient.delete(
          any,
          headers: anyNamed('headers'),
        ),
      ).thenAnswer((_) async => http.Response('', 200));

      // Act
      await datasourceImp.deleteProduct(tId);

      // Assert
      verify(
        mockHttpClient.delete(
          Uri.parse(
              'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/$tId'),
          headers: {'Content-Type': 'application/json'},
        ),
      );
    });

    test('should return a server error when status code is not 200', () async {
      // Arrange
      when(
        mockHttpClient.delete(
          any,
          headers: anyNamed('headers'),
        ),
      ).thenAnswer((_) async => http.Response('', 404));

      // Act & Assert
      expect(
        () async => await datasourceImp.deleteProduct(tId),
        throwsA(isA<ServerException>()),
      );

      // Verify
      verify(
        mockHttpClient.delete(
          Uri.parse(
              'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/$tId'),
          headers: {'Content-Type': 'application/json'},
        ),
      );
    });
  });


  


}
