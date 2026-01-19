// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Gallery)
const galleryProvider = GalleryFamily._();

final class GalleryProvider extends $NotifierProvider<Gallery, GalleryState> {
  const GalleryProvider._(
      {required GalleryFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'galleryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$galleryHash();

  @override
  String toString() {
    return r'galleryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Gallery create() => Gallery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GalleryState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GalleryState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GalleryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$galleryHash() => r'0e29e6337e1843356af2c83e5d5a39e6bf9a073f';

final class GalleryFamily extends $Family
    with
        $ClassFamilyOverride<Gallery, GalleryState, GalleryState, GalleryState,
            int> {
  const GalleryFamily._()
      : super(
          retry: null,
          name: r'galleryProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  GalleryProvider call(
    int totalCount,
  ) =>
      GalleryProvider._(argument: totalCount, from: this);

  @override
  String toString() => r'galleryProvider';
}

abstract class _$Gallery extends $Notifier<GalleryState> {
  late final _$args = ref.$arg as int;
  int get totalCount => _$args;

  GalleryState build(
    int totalCount,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<GalleryState, GalleryState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<GalleryState, GalleryState>,
        GalleryState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
