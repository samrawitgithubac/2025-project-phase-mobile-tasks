import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:ecommerce_app/features/product/domain/usecases/create_product_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecases/delete_product_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecases/update_product_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecases/usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecases/view_all_products_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecases/view_specific_product_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';


part 'product_bloc_event.dart';
part 'product_bloc_state.dart';

class ProductBlocBloc extends Bloc<ProductBlocEvent, ProductBlocState> {
  final CreateProductUseCase createProduct;
  final DeleteProductUseCase deleteProduct;
  final UpdateProductUseCase updateProduct;
  final ViewAllProductsUseCase fetchAllProduct;
  final ViewSpecificProductUseCase fetchSingleProduct;
  ProductBlocBloc(
    this.createProduct, 
    this.deleteProduct, 
    this.updateProduct, 
    this.fetchAllProduct, 
    this.fetchSingleProduct
    ) : super(ProductBlocInitial()) {
      on<LoadAllProductsEvent>(_onLoadAllProducts);
      on<GetSingleProductEvent>(_onGetSingleProduct);
      on<CreateProductEvent>(_onCreateProduct);
      on<DeleteProductEvent>(_onDeleteProduct);
      on<UpdateProductEvent>(_onUpdateProduct);
    }

    // }{
    // on<ProductBlocEvent>((event, emit) {
    //   // TODO: implement event handler
    // });
  Future<void> _onLoadAllProducts(
  LoadAllProductsEvent event,
  Emitter<ProductBlocState> emit,
) async {
  emit(const LoadingState());
  final result = await fetchAllProduct(NoParams());
  result.fold(
    (failure) => emit(ErrorState(message: failure.message)),
    (products) => emit(LoadedAllProductsState(products)),
  );
}

Future<void> _onGetSingleProduct(
  GetSingleProductEvent event,
  Emitter<ProductBlocState> emit,
) async {
  emit(const LoadingState());
  final result = await fetchSingleProduct(event.id);
  result.fold(
    (failure) => emit(ErrorState(message: failure.message)),
    (product) => emit(LoadedSingleProductState(product)),
  );
}

Future<void> _onCreateProduct(
  CreateProductEvent event,
  Emitter<ProductBlocState> emit,
) async {
  emit(const LoadingState());
  final result = await createProduct(event.product);
  result.fold(
    (failure) => emit(ErrorState(message: failure.message)),
    (_) => add(LoadAllProductsEvent()),
  );
}

Future<void> _onDeleteProduct(
  DeleteProductEvent event,
  Emitter<ProductBlocState> emit,
) async {
  emit(const LoadingState());
  final result = await deleteProduct(event.id);
  result.fold(
    (failure) => emit(ErrorState(message: failure.message)),
    (_) => add(LoadAllProductsEvent()),
  );
}

Future<void> _onUpdateProduct(
  UpdateProductEvent event,
  Emitter<ProductBlocState> emit,
) async {
  emit(const LoadingState());
  final result = await updateProduct(event.product);
  result.fold(
    (failure) => emit(ErrorState(message: failure.message)),
    (_) => add(LoadAllProductsEvent()),
  );
}


  
}
