// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchState {
  List<Product> get products;
  List<Product> get filteredProducts;
  String get query;
  String? get selectedCategory;
  String? get condition;
  double get minPrice;
  double get maxPrice;
  bool get isLoading;
  String? get errorMessage;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SearchStateCopyWith<SearchState> get copyWith =>
      _$SearchStateCopyWithImpl<SearchState>(this as SearchState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SearchState &&
            const DeepCollectionEquality().equals(other.products, products) &&
            const DeepCollectionEquality()
                .equals(other.filteredProducts, filteredProducts) &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            (identical(other.condition, condition) ||
                other.condition == condition) &&
            (identical(other.minPrice, minPrice) ||
                other.minPrice == minPrice) &&
            (identical(other.maxPrice, maxPrice) ||
                other.maxPrice == maxPrice) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(products),
      const DeepCollectionEquality().hash(filteredProducts),
      query,
      selectedCategory,
      condition,
      minPrice,
      maxPrice,
      isLoading,
      errorMessage);

  @override
  String toString() {
    return 'SearchState(products: $products, filteredProducts: $filteredProducts, query: $query, selectedCategory: $selectedCategory, condition: $condition, minPrice: $minPrice, maxPrice: $maxPrice, isLoading: $isLoading, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $SearchStateCopyWith<$Res> {
  factory $SearchStateCopyWith(
          SearchState value, $Res Function(SearchState) _then) =
      _$SearchStateCopyWithImpl;
  @useResult
  $Res call(
      {List<Product> products,
      List<Product> filteredProducts,
      String query,
      String? selectedCategory,
      String? condition,
      double minPrice,
      double maxPrice,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class _$SearchStateCopyWithImpl<$Res> implements $SearchStateCopyWith<$Res> {
  _$SearchStateCopyWithImpl(this._self, this._then);

  final SearchState _self;
  final $Res Function(SearchState) _then;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = null,
    Object? filteredProducts = null,
    Object? query = null,
    Object? selectedCategory = freezed,
    Object? condition = freezed,
    Object? minPrice = null,
    Object? maxPrice = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      products: null == products
          ? _self.products
          : products // ignore: cast_nullable_to_non_nullable
              as List<Product>,
      filteredProducts: null == filteredProducts
          ? _self.filteredProducts
          : filteredProducts // ignore: cast_nullable_to_non_nullable
              as List<Product>,
      query: null == query
          ? _self.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      selectedCategory: freezed == selectedCategory
          ? _self.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      condition: freezed == condition
          ? _self.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as String?,
      minPrice: null == minPrice
          ? _self.minPrice
          : minPrice // ignore: cast_nullable_to_non_nullable
              as double,
      maxPrice: null == maxPrice
          ? _self.maxPrice
          : maxPrice // ignore: cast_nullable_to_non_nullable
              as double,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [SearchState].
extension SearchStatePatterns on SearchState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_SearchState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SearchState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_SearchState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SearchState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_SearchState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SearchState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            List<Product> products,
            List<Product> filteredProducts,
            String query,
            String? selectedCategory,
            String? condition,
            double minPrice,
            double maxPrice,
            bool isLoading,
            String? errorMessage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SearchState() when $default != null:
        return $default(
            _that.products,
            _that.filteredProducts,
            _that.query,
            _that.selectedCategory,
            _that.condition,
            _that.minPrice,
            _that.maxPrice,
            _that.isLoading,
            _that.errorMessage);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            List<Product> products,
            List<Product> filteredProducts,
            String query,
            String? selectedCategory,
            String? condition,
            double minPrice,
            double maxPrice,
            bool isLoading,
            String? errorMessage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SearchState():
        return $default(
            _that.products,
            _that.filteredProducts,
            _that.query,
            _that.selectedCategory,
            _that.condition,
            _that.minPrice,
            _that.maxPrice,
            _that.isLoading,
            _that.errorMessage);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            List<Product> products,
            List<Product> filteredProducts,
            String query,
            String? selectedCategory,
            String? condition,
            double minPrice,
            double maxPrice,
            bool isLoading,
            String? errorMessage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SearchState() when $default != null:
        return $default(
            _that.products,
            _that.filteredProducts,
            _that.query,
            _that.selectedCategory,
            _that.condition,
            _that.minPrice,
            _that.maxPrice,
            _that.isLoading,
            _that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _SearchState extends SearchState {
  const _SearchState(
      {final List<Product> products = const [],
      final List<Product> filteredProducts = const [],
      this.query = '',
      this.selectedCategory,
      this.condition,
      this.minPrice = 0.0,
      this.maxPrice = 100000.0,
      this.isLoading = false,
      this.errorMessage})
      : _products = products,
        _filteredProducts = filteredProducts,
        super._();

  final List<Product> _products;
  @override
  @JsonKey()
  List<Product> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  final List<Product> _filteredProducts;
  @override
  @JsonKey()
  List<Product> get filteredProducts {
    if (_filteredProducts is EqualUnmodifiableListView)
      return _filteredProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredProducts);
  }

  @override
  @JsonKey()
  final String query;
  @override
  final String? selectedCategory;
  @override
  final String? condition;
  @override
  @JsonKey()
  final double minPrice;
  @override
  @JsonKey()
  final double maxPrice;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SearchStateCopyWith<_SearchState> get copyWith =>
      __$SearchStateCopyWithImpl<_SearchState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SearchState &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            const DeepCollectionEquality()
                .equals(other._filteredProducts, _filteredProducts) &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            (identical(other.condition, condition) ||
                other.condition == condition) &&
            (identical(other.minPrice, minPrice) ||
                other.minPrice == minPrice) &&
            (identical(other.maxPrice, maxPrice) ||
                other.maxPrice == maxPrice) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_products),
      const DeepCollectionEquality().hash(_filteredProducts),
      query,
      selectedCategory,
      condition,
      minPrice,
      maxPrice,
      isLoading,
      errorMessage);

  @override
  String toString() {
    return 'SearchState(products: $products, filteredProducts: $filteredProducts, query: $query, selectedCategory: $selectedCategory, condition: $condition, minPrice: $minPrice, maxPrice: $maxPrice, isLoading: $isLoading, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$SearchStateCopyWith<$Res>
    implements $SearchStateCopyWith<$Res> {
  factory _$SearchStateCopyWith(
          _SearchState value, $Res Function(_SearchState) _then) =
      __$SearchStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<Product> products,
      List<Product> filteredProducts,
      String query,
      String? selectedCategory,
      String? condition,
      double minPrice,
      double maxPrice,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class __$SearchStateCopyWithImpl<$Res> implements _$SearchStateCopyWith<$Res> {
  __$SearchStateCopyWithImpl(this._self, this._then);

  final _SearchState _self;
  final $Res Function(_SearchState) _then;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? products = null,
    Object? filteredProducts = null,
    Object? query = null,
    Object? selectedCategory = freezed,
    Object? condition = freezed,
    Object? minPrice = null,
    Object? maxPrice = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_SearchState(
      products: null == products
          ? _self._products
          : products // ignore: cast_nullable_to_non_nullable
              as List<Product>,
      filteredProducts: null == filteredProducts
          ? _self._filteredProducts
          : filteredProducts // ignore: cast_nullable_to_non_nullable
              as List<Product>,
      query: null == query
          ? _self.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      selectedCategory: freezed == selectedCategory
          ? _self.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      condition: freezed == condition
          ? _self.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as String?,
      minPrice: null == minPrice
          ? _self.minPrice
          : minPrice // ignore: cast_nullable_to_non_nullable
              as double,
      maxPrice: null == maxPrice
          ? _self.maxPrice
          : maxPrice // ignore: cast_nullable_to_non_nullable
              as double,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
