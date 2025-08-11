import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';

import '../../doamin/entities/product.dart';
import '../../data/models/product_model.dart';
import '../../doamin/usecases/create_new_product.dart' as create_product;
import '../../doamin/usecases/delete_product.dart' as delete_product;
import '../../doamin/usecases/update_product.dart' as update_product;
import '../../doamin/usecases/view_all_products.dart' as view_all;
import '../../doamin/usecases/view_specific_product.dart' as view_specific;
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final view_all.ViewAllProductsUsecase viewAllProducts;
  final view_specific.ViewProductUsecase viewProduct;
  final create_product.CreateProductUsecase createProduct;
  final update_product.UpdateProductUsecase updateProduct;
  final delete_product.DeleteProductUsecase deleteProduct;

  ProductBloc({
    required this.viewAllProducts,
    required this.viewProduct,
    required this.createProduct,
    required this.updateProduct,
    required this.deleteProduct,
  }) : super(ProductInitial()) {
    on<LoadAllProducts>((event, emit) async {
      emit(ProductLoading());
      final result = await viewAllProducts(const NoParams());
      result.fold(
        (failure) => emit(ProductError(failure.message)),
        (products) => emit(ProductsLoaded(products
            .map((p) => ProductModel(
                  id: p.id,
                  name: p.name,
                  description: p.description,
                  imageUrl: p.imageUrl,
                  price: p.price,
                ))
            .toList())),
      );
    });

    on<LoadProductById>((event, emit) async {
      emit(ProductLoading());
      final result =
          await viewProduct(view_specific.Params(id: event.productId));
      result.fold(
        (failure) => emit(ProductError(failure.message)),
        (product) => emit(ProductLoaded(ProductModel(
          id: product.id,
          name: product.name,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price,
        ))),
      );
    });

    on<CreateProduct>((event, emit) async {
      emit(ProductLoading());
      final result =
          await createProduct(create_product.Params(product: event.product));
      result.fold(
        (failure) => emit(ProductError(failure.message)),
        (_) {
          emit(ProductOperationSuccess());
          add(LoadAllProducts());
        },
      );
    });

    on<UpdateProduct>((event, emit) async {
      emit(ProductLoading());
      final result =
          await updateProduct(update_product.Params(product: event.product));
      result.fold(
        (failure) => emit(ProductError(failure.message)),
        (_) {
          emit(ProductOperationSuccess());
          add(LoadAllProducts());
        },
      );
    });

    on<DeleteProduct>((event, emit) async {
      emit(ProductLoading());
      final result =
          await deleteProduct(delete_product.Params(id: event.productId));
      result.fold(
        (failure) => emit(ProductError(failure.message)),
        (_) {
          emit(ProductOperationSuccess());
          add(LoadAllProducts());
        },
      );
    });
  }
}
