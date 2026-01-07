import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/data/providers/search/search_filters_notifier.dart';
import 'package:saglamspot/data/providers/search/search_notifier.dart';
import 'package:saglamspot/data/providers/search/search_state.dart';

final searchProvider =
    NotifierProvider<SearchNotifier, SearchState>(SearchNotifier.new);

final searchFiltersProvider =
    NotifierProvider<SearchFiltersNotifier, SearchState>(
        SearchFiltersNotifier.new);
