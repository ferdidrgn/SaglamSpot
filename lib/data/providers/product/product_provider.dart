import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/repositories/product_repository_provider.dart';
import 'product_notifier.dart';
import 'product_state.dart';

final productProvider = StateNotifierProvider<ProductNotifier, ProductState>((final ref) {
  final repository = ref.watch(productRepositoryProvider);
  return ProductNotifier(repository);
});
