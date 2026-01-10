import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'search_state.dart';

part 'search_filters_notifier.g.dart';

@riverpod
class SearchFiltersNotifier extends _$SearchFiltersNotifier {
  @override
  SearchState build() => const SearchState();

  void setCondition(final String? condition) => state =
      state.copyWith(condition: condition == 'Hepsi' ? null : condition);

  void setPriceRange(final double min, final double max) =>
      state = state.copyWith(minPrice: min, maxPrice: max);

  void reset() => state = const SearchState();
}
