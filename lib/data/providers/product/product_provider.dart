import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/repositories/product_repository_provider.dart';
import '../../../domain/usecases/product/add_product_usecase.dart';
import '../../../domain/usecases/product/delete_product_usecase.dart';
import '../../../domain/usecases/product/filter_product_usecase.dart';
import '../../../domain/usecases/product/get_products_usecase.dart';
import '../../../domain/usecases/product/update_product_usecase.dart';
import 'product_notifier.dart';
import 'product_state.dart';

final productProvider =
    NotifierProvider<ProductNotifier, ProductState>(ProductNotifier.new);

// ProductsUseCase providers
final getProductsUseCaseProvider = Provider<GetProductsUseCase>((final ref) =>
    GetProductsUseCaseImpl(ref.watch(productRepositoryProvider)));

final addProductUseCaseProvider = Provider<AddProductUseCase>(
    (final ref) => AddProductUseCaseImpl(ref.watch(productRepositoryProvider)));

final updateProductUseCaseProvider = Provider<UpdateProductUseCase>(
    (final ref) =>
        UpdateProductUseCaseImpl(ref.watch(productRepositoryProvider)));

final deleteProductUseCaseProvider = Provider<DeleteProductUseCase>(
    (final ref) =>
        DeleteProductUseCaseImpl(ref.watch(productRepositoryProvider)));

final filterProductUseCaseProvider = Provider<FilterProductUseCase>(
    (final ref) =>
        FilterProductUseCaseImpl(ref.watch(productRepositoryProvider)));
