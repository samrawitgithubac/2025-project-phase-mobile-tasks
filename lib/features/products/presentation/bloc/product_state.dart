import 'package:equatable/equatable.dart';
import '../../data/models/product_model.dart';

abstract class ProductState extends Equatable {
  const ProductState();
  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<ProductModel> products;
  const ProductsLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class ProductLoaded extends ProductState {
  final ProductModel product;
  const ProductLoaded(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductOperationSuccess extends ProductState {}

class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}
