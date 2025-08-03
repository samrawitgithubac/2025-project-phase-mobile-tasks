import 'dart:core';

import 'package:ecommerce_app/features/product/data/models/Product_model.dart';
// import 'package:ecommerce_app/features/product/domain/entities/product.dart';

abstract class ProductLocalDataSource {
  //to cache and to get the cache
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel>getProductById(int id);
  Future<void> cacheProducts(List<ProductModel> products);
}