import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Admin > Bildirimler ekranındaki "Bildirimi Gönder" butonunun çağırdığı
/// gerçek gönderim — `functions/index.js > sendCampaignNotification`
/// (Admin SDK ile isAdmin() doğrulaması sunucu tarafında tekrarlanır,
/// bkz. o fonksiyondaki assertIsAdmin). Aynı callable, web-genesis admin
/// panelinden de (farklı bir SDK ile) çağrılır — tek gönderim mantığı,
/// iki istemci.
class CampaignSendResult {
  final int sentCount; // -1: "all" segmentinde topic'e gönderildi, kesin sayı yok.
  const CampaignSendResult(this.sentCount);
}

class CampaignNotificationNotifier
    extends AsyncNotifier<CampaignSendResult?> {
  @override
  FutureOr<CampaignSendResult?> build() => null;

  Future<void> send({
    required final String title,
    required final String body,
    required final String segment,
    final String? linkType,
    final String? productId,
    final String? page,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final callable = FirebaseFunctions.instance.httpsCallable(
        'sendCampaignNotification',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
      );
      final response = await callable.call<Map<String, dynamic>>({
        'title': title,
        'body': body,
        'segment': segment,
        if (linkType != null) 'linkType': linkType,
        if (productId != null) 'productId': productId,
        if (page != null) 'page': page,
      });
      final data = Map<String, dynamic>.from(response.data as Map);
      return CampaignSendResult(data['sentCount'] as int? ?? -1);
    });
  }

  void reset() => state = const AsyncData(null);
}

final campaignNotificationProvider = AsyncNotifierProvider<
    CampaignNotificationNotifier, CampaignSendResult?>(
  CampaignNotificationNotifier.new,
);
