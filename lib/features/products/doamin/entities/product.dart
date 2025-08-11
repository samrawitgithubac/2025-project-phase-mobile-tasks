import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  const Product(
      {required this.id,
      required this.name,
      required this.description,
      required this.imageUrl,
      required this.price});

  @override
  List<Object> get props => [id, name, description, imageUrl, price];
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        imageUrl: json['imageUrl'] as String,
        price: (json['price'] as num).toDouble());
  }
}
