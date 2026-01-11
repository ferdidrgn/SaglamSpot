import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entites/product.dart';

part 'product_state.freezed.dart';

@freezed
class ProductState with _$ProductState {
  const factory ProductState({
    final List<Product>? dataList,
    final Product? dataSingle,
    @Default(false) final bool isLoading,
    final String? errorMessage,
  }) = _ProductState;

  @override
  // TODO: implement dataList
  List<Product>? get dataList => throw UnimplementedError();

  @override
  // TODO: implement dataSingle
  Product? get dataSingle => throw UnimplementedError();

  @override
  // TODO: implement errorMessage
  String? get errorMessage => throw UnimplementedError();

  @override
  // TODO: implement isLoading
  bool get isLoading => throw UnimplementedError();
}
