import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'search_state.dart';

class SearchFiltersNotifier extends Notifier<SearchState> {
  @override
  SearchState build() => const SearchState();

  void setCondition(final String? condition) {
    state = state.copyWith(condition: condition == 'Hepsi' ? null : condition);
  }

  void setPriceRange(final double min, final double max) {
    state = state.copyWith(minPrice: min, maxPrice: max);
  }

  void reset() {
    state = const SearchState();
  }
}
