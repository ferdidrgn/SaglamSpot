import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/entities/product.dart';

// Events
abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {
  const LoadProducts();
}

class FilterProducts extends ProductEvent {
  final String? condition;
  final double minPrice;
  final double maxPrice;

  const FilterProducts({
    this.condition,
    required this.minPrice,
    required this.maxPrice,
  });

  @override
  List<Object?> get props => [condition, minPrice, maxPrice];
}

class SearchProducts extends ProductEvent {
  final String query;

  const SearchProducts({required this.query});

  @override
  List<Object?> get props => [query];
}

class AddProduct extends ProductEvent {
  final Product product;
  final List<String> images;

  const AddProduct(this.product, this.images);

  @override
  List<Object?> get props => [product, images];
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

// States
abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;

  const ProductLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object> get props => [message];
}

class ProductAdded extends ProductState {}

class ProductUpdated extends ProductState {}

class ProductDeleted extends ProductState {}

// Bloc
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc({required this.repository}) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<FilterProducts>(_onFilterProducts);
    on<SearchProducts>(_onSearchProducts);
    on<AddProduct>(_onAddProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
  }

  Future<void> _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await repository.getProducts();
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(products)),
    );
  }

  Future<void> _onFilterProducts(FilterProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await repository.getFilteredProducts(
      condition: event.condition,
      minPrice: event.minPrice,
      maxPrice: event.maxPrice,
    );
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(products)),
    );
  }

  Future<void> _onSearchProducts(SearchProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await repository.getProducts();
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) {
        final filteredProducts = _filterProductsByQuery(products, event.query);
        emit(ProductLoaded(filteredProducts));
      },
    );
  }

  Future<void> _onAddProduct(AddProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await repository.addProduct(event.product, event.images);
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (_) => emit(ProductAdded()),
    );
  }

  Future<void> _onUpdateProduct(UpdateProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await repository.updateProduct(event.product);
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (_) => emit(ProductUpdated()),
    );
  }

  Future<void> _onDeleteProduct(DeleteProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await repository.deleteProduct(event.productId);
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (_) => emit(ProductDeleted()),
    );
  }

  List<Product> _filterProductsByQuery(List<Product> products, String query) {
    final lowerCaseQuery = query.toLowerCase();
    return products.where((product) {
      return product.name.toLowerCase().contains(lowerCaseQuery) ||
             product.desc.toLowerCase().contains(lowerCaseQuery);
    }).toList();
  }
}