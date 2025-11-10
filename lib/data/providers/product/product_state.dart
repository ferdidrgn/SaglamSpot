import '../../../core/common/base_loadable_state.dart';
import '../../../domain/entities/product.dart';

class ProductState extends LoadableState<Product, List<Product>> {
  const ProductState({
    super.dataList,
    super.dataSingle,
    super.isLoading = false,
    super.errorMessage,
  });

  @override
  ProductState copyWith({
    final List<Product>? dataList,
    final Product? dataSingle,
    final bool? isLoading,
    final String? errorMessage,
  }) =>
      ProductState(
        dataList: dataList ?? this.dataList,
        dataSingle: dataSingle ?? this.dataSingle,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [
        dataList,
        dataSingle,
        isLoading,
        errorMessage,
      ];
}
