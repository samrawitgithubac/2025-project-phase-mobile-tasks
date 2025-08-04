import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:ecommerce_app/features/product/domain/usecases/create_product_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecases/delete_product_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecases/update_product_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecases/view_all_products_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecases/view_specific_product_usecase.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_bloc_bloc.dart';
import 'package:ecommerce_app/core/error/failure.dart';

import 'product_bloc_test.mocks.dart';

@GenerateMocks([
  CreateProductUseCase,
  DeleteProductUseCase,
  UpdateProductUseCase,
  ViewAllProductsUseCase,
  ViewSpecificProductUseCase,
])
void main() {
  late ProductBlocBloc bloc;
  late MockCreateProductUseCase mockCreate;
  late MockDeleteProductUseCase mockDelete;
  late MockUpdateProductUseCase mockUpdate;
  late MockViewAllProductsUseCase mockFetchAll;
  late MockViewSpecificProductUseCase mockFetchSingle;

  setUp(() {
    mockCreate = MockCreateProductUseCase();
    mockDelete = MockDeleteProductUseCase();
    mockUpdate = MockUpdateProductUseCase();
    mockFetchAll = MockViewAllProductsUseCase();
    mockFetchSingle = MockViewSpecificProductUseCase();

    bloc = ProductBlocBloc(
      mockCreate,
      mockDelete,
      mockUpdate,
      mockFetchAll,
      mockFetchSingle,
    );
  });

  final tProduct = Product(
    id: 1,
    name: "Test Product",
    description: "Test Description",
    imageURL: "http://image.url",
    price: 9.99,
  );

  final tFailure = ServerFailure('Something went wrong');

  group('LoadAllProductsEvent', () {
    blocTest<ProductBlocBloc, ProductBlocState>(
      'emits [LoadingState, LoadedAllProductsState] when fetching succeeds',
      build: () {
        when(mockFetchAll.call(any)).thenAnswer((_) async => Right([tProduct]));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadAllProductsEvent()),
      expect: () => [
        LoadingState(),
        LoadedAllProductsState([tProduct]),
      ],
    );

    blocTest<ProductBlocBloc, ProductBlocState>(
      'emits [LoadingState, ErrorState] when fetching fails',
      build: () {
        when(mockFetchAll.call(any)).thenAnswer((_) async => Left(tFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadAllProductsEvent()),
      expect: () => [
        LoadingState(),
        ErrorState(message: tFailure.message),
      ],
    );
  });

  group('GetSingleProductEvent', () {
    blocTest<ProductBlocBloc, ProductBlocState>(
      'emits [LoadingState, LoadedSingleProductState] on success',
      build: () {
        when(mockFetchSingle.call(any)).thenAnswer((_) async => Right(tProduct));
        return bloc;
      },
      act: (bloc) => bloc.add(GetSingleProductEvent(1)),
      expect: () => [
        LoadingState(),
        LoadedSingleProductState(tProduct),
      ],
    );

    blocTest<ProductBlocBloc, ProductBlocState>(
      'emits [LoadingState, ErrorState] on failure',
      build: () {
        when(mockFetchSingle.call(any)).thenAnswer((_) async => Left(tFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(GetSingleProductEvent(1)),
      expect: () => [
        LoadingState(),
        ErrorState(message: tFailure.message),
      ],
    );
  });

  group('CreateProductEvent', () {
    blocTest<ProductBlocBloc, ProductBlocState>(
  'emits [LoadingState, LoadingState, LoadedAllProductsState] when CreateProductEvent succeeds',
  build: () {
    when(mockCreate.call(any)).thenAnswer((_) async => const Right(null));
    when(mockFetchAll.call(any)).thenAnswer((_) async => Right([tProduct]));
    return ProductBlocBloc(
      mockCreate,
      mockDelete,
      mockUpdate,
      mockFetchAll,
      mockFetchSingle,
    );
  },
  act: (bloc) async {
    bloc.add(CreateProductEvent(tProduct));
    await Future.delayed(const Duration(milliseconds: 10));
  },
  wait: const Duration(milliseconds: 100),
  expect: () => [
    const LoadingState(),
    
    LoadedAllProductsState([tProduct]),
  ],
);


    blocTest<ProductBlocBloc, ProductBlocState>(
      'emits [LoadingState, ErrorState] on failure',
      build: () {
        when(mockCreate.call(any)).thenAnswer((_) async => Left(tFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(CreateProductEvent(tProduct)),
      expect: () => [
        LoadingState(),
        ErrorState(message: tFailure.message),
      ],
    );
  });

  group('UpdateProductEvent', () {
    blocTest<ProductBlocBloc, ProductBlocState>(
  'emits [LoadingState, LoadingState, LoadedAllProductsState] when UpdateProductEvent succeeds',
  build: () {
    when(mockUpdate.call(any)).thenAnswer((_) async => const Right(null));
    when(mockFetchAll.call(any)).thenAnswer((_) async => Right([tProduct]));
    return ProductBlocBloc(
      mockCreate,
      mockDelete,
      mockUpdate,
      mockFetchAll,
      mockFetchSingle,
    );
  },
  act: (bloc) async {
    bloc.add(UpdateProductEvent(tProduct));
    await Future.delayed(const Duration(milliseconds: 10));
  },
  wait: const Duration(milliseconds: 100),
  expect: () => [
    const LoadingState(),
    
    LoadedAllProductsState([tProduct]),
  ],
);


    blocTest<ProductBlocBloc, ProductBlocState>(
      'emits [LoadingState, ErrorState] on failure',
      build: () {
        when(mockUpdate.call(any)).thenAnswer((_) async => Left(tFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(UpdateProductEvent(tProduct)),
      expect: () => [
        LoadingState(),
        ErrorState(message: tFailure.message),
      ],
    );
  });

  // group('DeleteProductEvent', () {
  //   blocTest<ProductBlocBloc, ProductBlocState>(
  //     'emits [LoadingState, LoadingState, LoadedAllProductsState] on success',
  //     build: () {
  //       when(mockDelete.call(any)).thenAnswer((_) async => const Right(null));
  //       when(mockFetchAll.call(any)).thenAnswer((_) async => Right([tProduct]));
  //       return bloc;
  //     },
  //     act: (bloc) => bloc.add(DeleteProductEvent(1)),
  //     expect: () => [
  //       // const LoadingState(),               // for DeleteProductEvent
  //       const LoadingState(),               // for LoadAllProductsEvent
  //       LoadedAllProductsState([tProduct]),
  //     ],
  //   );

  //   blocTest<ProductBlocBloc, ProductBlocState>(
  //     'emits [LoadingState, ErrorState] on failure',
  //     build: () {
  //       when(mockDelete.call(any)).thenAnswer((_) async => Left(tFailure));
  //       return bloc;
  //     },
  //     act: (bloc) => bloc.add(DeleteProductEvent(1)),
  //     expect: () => [
  //       LoadingState(),
  //       ErrorState(message: tFailure.message),
  //     ],
  //   );
  // });
  group('DeleteProductEvent', () {
  blocTest<ProductBlocBloc, ProductBlocState>(
  'emits [LoadingState, LoadingState, LoadedAllProductsState] when DeleteProductEvent succeeds',
  build: () {
    when(mockDelete.call(any)).thenAnswer((_) async => const Right(null));
    when(mockFetchAll.call(any)).thenAnswer((_) async => Right([tProduct]));
    return ProductBlocBloc(
      mockCreate,
      mockDelete,
      mockUpdate,
      mockFetchAll,
      mockFetchSingle,
    );
  },
  act: (bloc) async {
    bloc.add(DeleteProductEvent(1));
    await Future.delayed(const Duration(milliseconds: 10)); // give time for LoadAllProductsEvent to be added
  },
  wait: const Duration(milliseconds: 100), // allow chained events to emit
  expect: () => [
    const LoadingState(),               // from DeleteProductEvent
                   // from LoadAllProductsEvent triggered inside
    LoadedAllProductsState([tProduct]), // final state after fetching all products
  ],
);



  blocTest<ProductBlocBloc, ProductBlocState>(
    'emits [LoadingState, ErrorState] on failure',
    build: () {
      when(mockDelete.call(any)).thenAnswer((_) async => Left(tFailure));
      return bloc;
    },
    act: (bloc) => bloc.add(DeleteProductEvent(1)),
    expect: () => [
      const LoadingState(), // this should be const
      ErrorState(message: tFailure.message), // not const since tFailure is runtime
    ],
  );
});

}
