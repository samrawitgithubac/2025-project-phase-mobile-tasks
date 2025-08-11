import 'dart:convert';


import 'package:ecommerce_app/features/products/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  late ProductModel productModel;
  late Map<String, dynamic> jsonMap;

  setUp(() {
    jsonMap = json.decode(fixture('product.json')) as Map<String, dynamic>;
    productModel = ProductModel.fromJson(jsonMap);
  });

  test('should be a subclass of the Product entity', () {
    expect(productModel, isA<ProductModel>());
  });

  test('fromJson should return a valid model', () {
    final result = ProductModel.fromJson(jsonMap);
    expect(result, productModel);
  });

   test('toJson should return a valid map', () {
    final result = productModel.toJson();
    expect(result, equals(jsonMap));
  });
}

