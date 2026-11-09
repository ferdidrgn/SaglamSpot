import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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

/// Admin'e gönderim ÖNCESİ "kaç cihaza gerçekten ulaşacak" güveni vermek
/// için — aynı `functions/index.js > resolveCampaignSegment` mantığını
/// (sayım amaçlı, bildirim GÖNDERMEDEN) çalıştıran `getCampaignSegmentSize`
/// callable'ını çağırır. "all" segmenti FCM konusu abonesi olduğu ve bu
/// sayı Admin SDK'dan sorgulanamadığı için `null` döner — istemci bunu
/// "kesin sayı önceden gösterilemez" olarak gösterir. `segment` değişince
/// (ör. kullanıcı farklı bir chip'e dokununca) otomatik yeniden sorgular;
/// autoDispose, ekran kapanınca gereksiz son çağrıyı iptal eder.
final campaignSegmentSizeProvider =
    FutureProvider.autoDispose.family<int?, String>((final ref, final segment) async {
  final callable = FirebaseFunctions.instance.httpsCallable(
    'getCampaignSegmentSize',
    options: HttpsCallableOptions(timeout: const Duration(seconds: 15)),
  );
  final response = await callable.call<Map<String, dynamic>>({'segment': segment});
  final data = Map<String, dynamic>.from(response.data as Map);
  return data['size'] as int?;
});

/// Daha önce gönderilmiş bir kampanyaya ait tek kayıt — `notification_
/// broadcasts`'tan (bkz. functions/index.js > sendCampaignNotification'ın
/// yazdığı `segment`/`sentCount` alanları) okunur. Bu alanlar eklenmeden
/// önce hangi kampanyanın hangi segmente/kaç cihaza ulaştığı hiçbir yerde
/// kalıcı görünmüyordu — sadece o anki admin'in ekranındaki tek seferlik
/// SnackBar'da.
class CampaignHistoryEntry {
  final String title;
  final String body;
  final String? segment;
  final int? sentCount; // null: eski kayıt (segment/sentCount henüz yoktu). -1: "all" topic.
  final DateTime createdAt;

  const CampaignHistoryEntry({
    required this.title,
    required this.body,
    required this.segment,
    required this.sentCount,
    required this.createdAt,
  });
}

/// Admin > Bildirimler ekranındaki "Son Kampanyalar" listesi — son
/// gönderilen kampanyaları (type == admin_campaign) tarihe göre azalan
/// sırada getirir. `notification_broadcasts` herkese açık okunabilir
/// (bkz. firestore.rules — müşteri uygulaması da gelen kutusu senkronu
/// için aynı koleksiyonu okuyor), bu yüzden burada ekstra bir admin
/// kapısına gerek yok.
final campaignHistoryProvider =
    StreamProvider.autoDispose<List<CampaignHistoryEntry>>((final ref) {
  return FirebaseFirestore.instance
      .collection('notification_broadcasts')
      .where('type', isEqualTo: 'admin_campaign')
      .orderBy('createdAt', descending: true)
      .limit(10)
      .snapshots()
      .map((final snap) => snap.docs.map((final doc) {
            final data = doc.data();
            final createdAt = data['createdAt'];
            return CampaignHistoryEntry(
              title: data['title'] as String? ?? '',
              body: data['body'] as String? ?? '',
              segment: data['segment'] as String?,
              sentCount: data['sentCount'] as int?,
              createdAt:
                  createdAt is Timestamp ? createdAt.toDate() : DateTime.now(),
            );
          }).toList());
});
