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

// Bloc
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc({required this.repository}) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<FilterProducts>(_onFilterProducts);
    on<SearchProducts>(_onSearchProducts);
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

  List<Product> _filterProductsByQuery(List<Product> products, String query) {
    final lowerCaseQuery = query.toLowerCase();
    return products.where((product) {
      return product.name.toLowerCase().contains(lowerCaseQuery) ||
             product.desc.toLowerCase().contains(lowerCaseQuery);
    }).toList();
  }
}