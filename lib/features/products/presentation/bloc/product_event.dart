import 'package:equatable/equatable.dart';
import '../../doamin/entities/product.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllProducts extends ProductEvent {}

class LoadProductById extends ProductEvent {
  final String productId;
  const LoadProductById(this.productId);

  @override
  List<Object?> get props => [productId];
}

class CreateProduct extends ProductEvent {
  final Product product;
  const CreateProduct(this.product);

  @override
  List<Object?> get props => [product];
}

class UpdateProduct extends ProductEvent {
  final Product product;
  const UpdateProduct(this.product);

  @override
  List<Object?> get props => [product];
}

class DeleteProduct extends ProductEvent {
  final String productId;
  const DeleteProduct(this.productId);

  @override
  List<Object?> get props => [productId];
}
