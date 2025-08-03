import 'dart:convert';

import 'package:ecommerce_app/features/product/data/models/Product_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/featuer_reader.dart';

void main(){
  final testProductModel=ProductModel(id: 1, name: 'name', description: 'description', imageURL: 'imageURL', price: 12.00);
  // test('', () async{
  //   //arrange
  //   //act
  //   //assert
  //   expect(testProductModel, isA<ProductModel>);

  // });
  group('fromJson', () {
    test("should return a valid model", () async{
      //arrange
      final Map<String,dynamic> jsonMap=json.decode(fixture('product_fixture.json'));
      //act
      final result=ProductModel.fromJson(jsonMap);
      //assert
      expect(result, testProductModel);

    });
  });
  group('toJson', (){
    test('should return a json map', (){
      //arrange
      //act
      final result= testProductModel.toJson();
      //assert
      final expectMap={
        "id":1,
        "name":"name",
        "description": "description",
        "imageURL": "imageURL",
        "price": 12.0,
      };
      expect(result, expectMap);
    });
  });
}