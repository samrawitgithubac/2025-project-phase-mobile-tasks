import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../../core/error/exception.dart';
import '../../doamin/entities/product.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDatasource {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel> getProductById(String id);
  Future<void> createProduct(Product product);
  Future<void> deleteProduct(String id);
  Future<void> updateProduct(Product product);
}

class ProductRemoteDatasourceImp implements ProductRemoteDatasource {
  final http.Client httpClient;
  ProductRemoteDatasourceImp(this.httpClient);
  @override
  Future<void> createProduct(Product product) async {
    final response = await httpClient.post(
      Uri.parse(
          'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw ServerException();
    }
  }
  

  @override
  Future<void> deleteProduct(String id)async {
   final response = await httpClient.delete(
      Uri.parse(
          'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return ;
    } else {
      throw ServerException();
    }
  }

  @override
@override
  Future<List<ProductModel>> getAllProducts() async {
    final response = await httpClient.get(
      Uri.parse(
          'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> jsonList = jsonResponse['data'];
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final response = await httpClient.get(
      Uri.parse(
          'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return ProductModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
 Future<void> updateProduct(Product product) async {
    final response = await httpClient.put(
      Uri.parse(
          'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/${product.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw ServerException();
    }
  }

}
