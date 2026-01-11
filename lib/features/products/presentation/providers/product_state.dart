import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entites/product.dart';

part 'product_state.freezed.dart';

@freezed
class ProductState with _$ProductState {
  const ProductState._(); // Eklendi

  const factory ProductState({
    final List<Product>? dataList,
    final Product? dataSingle,
    @Default(false) final bool isLoading,
    final String? errorMessage,
  }) = _ProductState;

  // Hataları gidermek için yönlendirmeler:
  @override
  List<Product>? get dataList => (this as _ProductState).dataList;

  @override
  Product? get dataSingle => (this as _ProductState).dataSingle;

  @override
  bool get isLoading => (this as _ProductState).isLoading;

  @override
  String? get errorMessage => (this as _ProductState).errorMessage;
}
