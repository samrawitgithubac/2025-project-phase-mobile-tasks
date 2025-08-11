

import '../../doamin/entities/product.dart';

class ProductModel extends Product {
   const ProductModel({
    required super.id,
    required super.name,
    required super.price,
    required super.description,
    required super.imageUrl,
  });

factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        imageUrl: json['imageUrl'] as String,
        price: (json['price'] as num).toDouble());
  }



Map<String,dynamic> toJson(){
   return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
    };
}

}


