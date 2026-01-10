import 'dart:developer' as dev;
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../errors/failures.dart';
import 'base_state.dart';

/// [BaseNotifierActionHandler], Notifier sınıflarına asenkron operasyon yönetimi yeteneği kazandırır.
/// 'on Notifier<T>' kısıtlaması, Riverpod 3 lifecycle metodlarına erişim sağlar.
mixin BaseNotifierActionHandler<T extends BaseState> on Notifier<T> {
  /// [execute], verilen [operation]'ı güvenli bir şekilde yürütür.
  /// Industrial: 'operationTag' ile loglama ve hata takibi kolaylaştırılır.
  Future<R?> execute<R>(
    final Future<Either<Failure, R>> Function() operation, {
    final String? operationTag,
    final String? customErrorMessage,
  }) async {
    final tag = operationTag ?? 'Operation';

    try {
      state = state.copyWith(isLoading: true, errorMessage: null) as T;

      dev.log('Executing $tag...', name: 'BaseActionHandler');
      final result = await operation();

      return result.fold(
        (final failure) {
          final error = _mapFailureToMessage(failure, customErrorMessage);

          dev.log('Error in $tag: $error',
              name: 'BaseActionHandler', error: failure);

          state = state.copyWith(isLoading: false, errorMessage: error) as T;
          return null;
        },
        (final success) {
          dev.log('$tag completed successfully.', name: 'BaseActionHandler');
          state = state.copyWith(isLoading: false, errorMessage: null) as T;
          return success;
        },
      );
    } catch (e, stackTrace) {
      dev.log('Unexpected Error in $tag',
          name: 'BaseActionHandler', error: e, stackTrace: stackTrace);

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Kritik bir hata oluştu. Lütfen teknik ekibe bildirin.',
      ) as T;
      return null;
    }
  }

  /// Failure nesnesini kullanıcı dostu metinlere dönüştürür.
  String _mapFailureToMessage(final Failure failure, final String? custom) {
    if (custom != null) return custom;

    // RuntimeType kontrolü ile endüstriyel hata eşleştirme
    return switch (failure.runtimeType.toString()) {
      'NetworkFailure' => 'Bağlantı hatası. Lütfen internetinizi kontrol edin.',
      'ServerFailure' => 'Sunucu hatası. Lütfen daha sonra tekrar deneyin.',
      'CacheFailure' => 'Önbellek hatası.',
      _ => failure.message,
    };
  }
}
