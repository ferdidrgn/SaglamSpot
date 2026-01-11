import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../products/domain/entites/product.dart';

part 'search_state.freezed.dart';

@freezed
class SearchState with _$SearchState {
  const SearchState._(); // Bu satır üretilen kodun metodlarını kullanmanı sağlar

  const factory SearchState({
    @Default([]) final List<Product> products,
    @Default([]) final List<Product> filteredProducts,
    @Default('') final String query,
    final String? selectedCategory,
    final String? condition,
    @Default(0.0) final double minPrice,
    @Default(100000.0) final double maxPrice,
    @Default(false) final bool isLoading,
    final String? errorMessage,
  }) = _SearchState;

  // IDE'nin "Missing implementation" hatasını bu yönlendirmelerle susturuyoruz:
  @override
  List<Product> get products => (this as _SearchState).products;

  @override
  List<Product> get filteredProducts => (this as _SearchState).filteredProducts;

  @override
  String get query => (this as _SearchState).query;

  @override
  String? get selectedCategory => (this as _SearchState).selectedCategory;

  @override
  String? get condition => (this as _SearchState).condition;

  @override
  double get minPrice => (this as _SearchState).minPrice;

  @override
  double get maxPrice => (this as _SearchState).maxPrice;

  @override
  bool get isLoading => (this as _SearchState).isLoading;

  @override
  String? get errorMessage => (this as _SearchState).errorMessage;

  bool get isFiltered =>
      query.isNotEmpty ||
      selectedCategory != null ||
      condition != null ||
      minPrice > 0 ||
      maxPrice < 100000;

  int get resultCount => filteredProducts.length;
}
