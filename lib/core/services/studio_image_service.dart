import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

enum StudioImageResult { success, quotaExceeded, failed }

class StudioImageOutcome {
  final StudioImageResult result;
  final String? studioImageUrl;

  const StudioImageOutcome(this.result, this.studioImageUrl);
}

/// remove.bg tabanlı "stüdyo" (arka plansız) görsel üretimi — istek her
/// zaman bir Firebase Cloud Function'a gider (`functions/index.js` ->
/// `removeProductBackground`); remove.bg API anahtarı YALNIZCA orada,
/// sunucu tarafı bir "secret" olarak durur, istemci koduna asla gömülmez.
///
/// Aylık 50 istek kotası fonksiyon tarafında (Firestore'da, transaction
/// ile) takip edilir. Kota dolduğunda bu servis sessizce
/// [StudioImageResult.quotaExceeded] döner — orijinal fotoğraf yüklemesi
/// bundan hiç etkilenmez, sadece "stüdyo" versiyonu atlanır.
class StudioImageService {
  StudioImageService._();

  /// Son yükleme turunda kota dolduğu için en az bir stüdyo görseli
  /// üretilemediyse true olur. Admin formu bunu dinleyip kullanıcıya
  /// "aylık stüdyo limiti doldu" bilgisini gösterir, sonra sıfırlar.
  static final ValueNotifier<bool> quotaExceededNotifier = ValueNotifier<bool>(false);

  static Future<StudioImageOutcome> generate(final String imageUrl) async {
    try {
      final callable = FirebaseFunctions.instance.httpsCallable(
        'removeProductBackground',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 45)),
      );
      final response = await callable.call<Map<String, dynamic>>({'imageUrl': imageUrl});
      final data = Map<String, dynamic>.from(response.data as Map);

      if (data['success'] == true) {
        return StudioImageOutcome(StudioImageResult.success, data['studioImageUrl'] as String?);
      }
      if (data['reason'] == 'quota_exceeded') {
        quotaExceededNotifier.value = true;
        return const StudioImageOutcome(StudioImageResult.quotaExceeded, null);
      }
      return const StudioImageOutcome(StudioImageResult.failed, null);
    } catch (e) {
      debugPrint('⚠️ Stüdyo görsel üretimi başarısız: $e');
      return const StudioImageOutcome(StudioImageResult.failed, null);
    }
  }
}
