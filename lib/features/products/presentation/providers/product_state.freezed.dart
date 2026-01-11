// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductState {
  List<Product>? get dataList;
  Product? get dataSingle;
  bool get isLoading;
  String? get errorMessage;

  /// Create a copy of ProductState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProductStateCopyWith<ProductState> get copyWith =>
      _$ProductStateCopyWithImpl<ProductState>(
          this as ProductState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProductState &&
            const DeepCollectionEquality().equals(other.dataList, dataList) &&
            (identical(other.dataSingle, dataSingle) ||
                other.dataSingle == dataSingle) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(dataList),
      dataSingle,
      isLoading,
      errorMessage);

  @override
  String toString() {
    return 'ProductState(dataList: $dataList, dataSingle: $dataSingle, isLoading: $isLoading, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $ProductStateCopyWith<$Res> {
  factory $ProductStateCopyWith(
          ProductState value, $Res Function(ProductState) _then) =
      _$ProductStateCopyWithImpl;
  @useResult
  $Res call(
      {List<Product>? dataList,
      Product? dataSingle,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class _$ProductStateCopyWithImpl<$Res> implements $ProductStateCopyWith<$Res> {
  _$ProductStateCopyWithImpl(this._self, this._then);

  final ProductState _self;
  final $Res Function(ProductState) _then;

  /// Create a copy of ProductState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dataList = freezed,
    Object? dataSingle = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      dataList: freezed == dataList
          ? _self.dataList
          : dataList // ignore: cast_nullable_to_non_nullable
              as List<Product>?,
      dataSingle: freezed == dataSingle
          ? _self.dataSingle
          : dataSingle // ignore: cast_nullable_to_non_nullable
              as Product?,
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

/// Adds pattern-matching-related methods to [ProductState].
extension ProductStatePatterns on ProductState {
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
    TResult Function(_ProductState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProductState() when $default != null:
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
    TResult Function(_ProductState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductState():
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
    TResult? Function(_ProductState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductState() when $default != null:
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
    TResult Function(List<Product>? dataList, Product? dataSingle,
            bool isLoading, String? errorMessage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProductState() when $default != null:
        return $default(_that.dataList, _that.dataSingle, _that.isLoading,
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
    TResult Function(List<Product>? dataList, Product? dataSingle,
            bool isLoading, String? errorMessage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductState():
        return $default(_that.dataList, _that.dataSingle, _that.isLoading,
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
    TResult? Function(List<Product>? dataList, Product? dataSingle,
            bool isLoading, String? errorMessage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductState() when $default != null:
        return $default(_that.dataList, _that.dataSingle, _that.isLoading,
            _that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ProductState extends ProductState {
  const _ProductState(
      {final List<Product>? dataList,
      this.dataSingle,
      this.isLoading = false,
      this.errorMessage})
      : _dataList = dataList,
        super._();

  final List<Product>? _dataList;
  @override
  List<Product>? get dataList {
    final value = _dataList;
    if (value == null) return null;
    if (_dataList is EqualUnmodifiableListView) return _dataList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final Product? dataSingle;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  /// Create a copy of ProductState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProductStateCopyWith<_ProductState> get copyWith =>
      __$ProductStateCopyWithImpl<_ProductState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProductState &&
            const DeepCollectionEquality().equals(other._dataList, _dataList) &&
            (identical(other.dataSingle, dataSingle) ||
                other.dataSingle == dataSingle) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_dataList),
      dataSingle,
      isLoading,
      errorMessage);

  @override
  String toString() {
    return 'ProductState(dataList: $dataList, dataSingle: $dataSingle, isLoading: $isLoading, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$ProductStateCopyWith<$Res>
    implements $ProductStateCopyWith<$Res> {
  factory _$ProductStateCopyWith(
          _ProductState value, $Res Function(_ProductState) _then) =
      __$ProductStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<Product>? dataList,
      Product? dataSingle,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class __$ProductStateCopyWithImpl<$Res>
    implements _$ProductStateCopyWith<$Res> {
  __$ProductStateCopyWithImpl(this._self, this._then);

  final _ProductState _self;
  final $Res Function(_ProductState) _then;

  /// Create a copy of ProductState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? dataList = freezed,
    Object? dataSingle = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_ProductState(
      dataList: freezed == dataList
          ? _self._dataList
          : dataList // ignore: cast_nullable_to_non_nullable
              as List<Product>?,
      dataSingle: freezed == dataSingle
          ? _self.dataSingle
          : dataSingle // ignore: cast_nullable_to_non_nullable
              as Product?,
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
