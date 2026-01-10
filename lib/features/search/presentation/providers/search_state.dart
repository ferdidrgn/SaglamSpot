import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../products/domain/entites/product.dart';

part 'search_state.freezed.dart';

@freezed
class SearchState with _$SearchState {
  // 1. Tüm alanlar burada tanımlanır. Freezed bunları otomatik üretir.
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

  // 2. KRİTİK: Bu satır varken yukarıdaki her şeyi manuel yazmana GEREK YOKTUR.
  // Bu satır, factory içindeki alanların somut (concrete) karşılığını sağlar.
  const SearchState._();

  // 3. Yardımcı Metodlar (Bunlar hata vermez)
  bool get isFiltered =>
      query.isNotEmpty ||
      selectedCategory != null ||
      condition != null ||
      minPrice > 0 ||
      maxPrice < 100000;

  int get resultCount => filteredProducts.length;

  @override
  // TODO: implement condition
  String? get condition => throw UnimplementedError();

  @override
  // TODO: implement errorMessage
  String? get errorMessage => throw UnimplementedError();

  @override
  // TODO: implement filteredProducts
  List<Product> get filteredProducts => throw UnimplementedError();

  @override
  // TODO: implement isLoading
  bool get isLoading => throw UnimplementedError();

  @override
  // TODO: implement maxPrice
  double get maxPrice => throw UnimplementedError();

  @override
  // TODO: implement minPrice
  double get minPrice => throw UnimplementedError();

  @override
  // TODO: implement products
  List<Product> get products => throw UnimplementedError();

  @override
  // TODO: implement query
  String get query => throw UnimplementedError();

  @override
  // TODO: implement selectedCategory
  String? get selectedCategory => throw UnimplementedError();
}
