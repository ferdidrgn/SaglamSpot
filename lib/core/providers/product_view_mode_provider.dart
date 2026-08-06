import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ProductViewMode { grid, list }

/// Kullanıcının ızgara/liste tercihi — sayfalar arasında paylaşılır
/// (bir sayfada liste seçersen diğerlerinde de liste görünür, "dinamik"
/// ve tutarlı bir deneyim için).
class ProductViewModeNotifier extends Notifier<ProductViewMode> {
  @override
  ProductViewMode build() => ProductViewMode.grid;

  void toggle() =>
      state = state == ProductViewMode.grid ? ProductViewMode.list : ProductViewMode.grid;

  void set(final ProductViewMode mode) => state = mode;
}

final productViewModeProvider =
    NotifierProvider<ProductViewModeNotifier, ProductViewMode>(
        ProductViewModeNotifier.new);
