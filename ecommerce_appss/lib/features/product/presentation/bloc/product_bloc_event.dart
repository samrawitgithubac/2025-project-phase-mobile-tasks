part of 'product_bloc_bloc.dart';

@immutable
sealed class ProductBlocEvent {}

class LoadAllProductsEvent extends ProductBlocEvent{}
class GetSingleProductEvent extends ProductBlocEvent{
  final int id;
  GetSingleProductEvent(this.id);
}
class UpdateProductEvent extends ProductBlocEvent{
  final Product product;
  UpdateProductEvent(this.product);
}
class DeleteProductEvent  extends ProductBlocEvent{
  final int id;
  DeleteProductEvent(this.id);
}
class CreateProductEvent  extends ProductBlocEvent{
  final Product product;
  CreateProductEvent(this.product);
}
