

import 'dart:convert';

import 'package:ecommerce_app/core/constants/api_constants.dart';
import 'package:ecommerce_app/core/error/exception.dart';
import 'package:ecommerce_app/features/product/data/models/Product_model.dart';
// import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:http/http.dart' as http;


abstract class ProductRemoteDataSource {
 
  Future< void> createProduct(ProductModel product) ;
   
   
  
  
  Future< void> updateProduct(ProductModel product) ; 
  
    // return const Right(null);
  

  Future< void> deleteProduct(int id);
  
  Future< List<ProductModel>> getAllProducts() ;
   
    // return const Right([]);
  
  
  Future< ProductModel> getProductById(int id) ;
  
    // return Right(Product(id: id, name: 'name', description: 'description', imageURL: 'imageURL', price: 10));
  

}
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource{
  final http.Client  client;
  ProductRemoteDataSourceImpl(this.client);
  @override
  Future<void> createProduct(ProductModel product) async {

    final response=await client.post(
      Uri.parse(baseUrl),
      headers:{'Content-Type':'application/json'},
      body:json.encode(product.toJson()),
    );
    if (response.statusCode!=201 && response.statusCode!=200){
      throw ServerException();
    }
  }

  @override
  Future<void> deleteProduct(int id)async {
   
    final response=await client.delete(
      Uri.parse('$baseUrl/$id'),
      headers:{'Content-Type':'application/json'},

      );
    if(response.statusCode!=200 && response.statusCode!=204){
      throw ServerException();
    }
  }

  @override
  Future<List<ProductModel>> getAllProducts()async {
 
    final response=await client.get(
      Uri.parse(baseUrl),
      headers: {'Content-Type':'application/json'},
    );
    if (response.statusCode==200){
      final List<dynamic> jsonList=json.decode(response.body);
      return jsonList.map((e)=>ProductModel.fromJson(e)).toList();
    }else{
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> getProductById(int id)async {
 
    final result=await client.get(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type':'application/json'}

    );
    if (result.statusCode==200){
      final Map<String,dynamic> jsonMap= json.decode(result.body);
      return ProductModel.fromJson(jsonMap);

    }else{
      throw ServerException();
    }
  }

  @override
  Future<void> updateProduct(ProductModel product)async {
    
    final response=await client.put(
      Uri.parse('$baseUrl/${product.id}'),
      headers:{'Content-Type':'application/json'},
      body:json.encode(product.toJson()),

    );
    if (response.statusCode!=200 && response.statusCode!=204){
      throw ServerException();
    }
  }
}