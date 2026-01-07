import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/features/search/presentation/providers/search_filters_notifier.dart';
import 'package:saglamspot/features/search/presentation/providers/search_notifier.dart';
import 'package:saglamspot/features/search/presentation/providers/search_state.dart';

final searchProvider =
    NotifierProvider<SearchNotifier, SearchState>(SearchNotifier.new);

final searchFiltersProvider =
    NotifierProvider<SearchFiltersNotifier, SearchState>(
        SearchFiltersNotifier.new);
