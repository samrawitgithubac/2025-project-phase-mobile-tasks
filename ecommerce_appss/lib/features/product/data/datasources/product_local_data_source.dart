import 'dart:convert';
import 'dart:core';

import 'package:ecommerce_app/core/error/exception.dart';
import 'package:ecommerce_app/features/product/data/models/Product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ecommerce_app/features/product/domain/entities/product.dart';

abstract class ProductLocalDataSource {
  //to cache and to get the cache
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel>getProductById(int id);
  Future<void> cacheProducts(List<ProductModel> products);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource{

  final SharedPreferences sharedPreferences;
  ProductLocalDataSourceImpl(this.sharedPreferences);
  static const cachedProductKey='CACHED_PRODUCTS';

  @override
  Future<void> cacheProducts(List<ProductModel> products)async {
   
    final jsonList=products.map((product)=>jsonEncode(product.toJson())).toList();
    await sharedPreferences.setStringList(cachedProductKey, jsonList);

  }

  @override
  Future<List<ProductModel>> getAllProducts() async{
   
    final jsonList=sharedPreferences.getStringList(cachedProductKey);
    if (jsonList !=null){
      return jsonList.map((jsonString)=>ProductModel.fromJson(jsonDecode(jsonString))).toList();

    }else{
      throw CacheException();
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async{
  
    final jsonList=sharedPreferences.getStringList(cachedProductKey);
    if (jsonList!= null){
      final products=jsonList.map((jsonString)=>ProductModel.fromJson(jsonDecode(jsonString))).toList();
      try{
        return products.firstWhere((product)=>product.id==id);
      }catch(_){
        throw CacheException();
      }
    }else{
      throw CacheException();
    }
  }
}