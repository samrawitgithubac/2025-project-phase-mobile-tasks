
part of 'product_bloc_bloc.dart';

@immutable
sealed class ProductBlocState extends Equatable {
  const ProductBlocState();

  @override
  List<Object?> get props => [];
}

final class ProductBlocInitial extends ProductBlocState {
  const ProductBlocInitial();
}

class EmptyState extends ProductBlocState {
  const EmptyState();
}

class LoadingState extends ProductBlocState {
  const LoadingState();
}

class LoadedAllProductsState extends ProductBlocState {
  final List<Product> products;
  const LoadedAllProductsState(this.products);

  @override
  List<Object?> get props => [products];
}

class LoadedSingleProductState extends ProductBlocState {
  final Product product;
  const LoadedSingleProductState(this.product);

  @override
  List<Object?> get props => [product];
}

class ErrorState extends ProductBlocState {
  final String message;
  const ErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

