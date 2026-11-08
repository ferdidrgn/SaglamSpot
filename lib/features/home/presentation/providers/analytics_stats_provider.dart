import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// `analytics_events` koleksiyonundaki TEK bir olay (bkz.
/// core/services/analytics_event_logger.dart) — Admin > İstatistikler
/// ekranının tarih filtreli grafik/tablolarının ham verisi.
class AnalyticsEvent {
  final String type; // 'view' | 'contact_click' | 'favorite' | 'sale'
  final String productId;
  final String category;
  final String platform; // 'web' | 'mobile'
  final double? price;
  final DateTime createdAt;

  const AnalyticsEvent({
    required this.type,
    required this.productId,
    required this.category,
    required this.platform,
    required this.createdAt,
    this.price,
  });

  factory AnalyticsEvent.fromMap(final Map<String, dynamic> data) {
    final createdAt = data['createdAt'];
    return AnalyticsEvent(
      type: data['type'] as String? ?? '',
      productId: data['productId'] as String? ?? '',
      category: data['category'] as String? ?? 'other',
      platform: data['platform'] as String? ?? 'mobile',
      price: (data['price'] as num?)?.toDouble(),
      createdAt: createdAt is Timestamp ? createdAt.toDate() : DateTime.now(),
    );
  }
}

/// Seçilen tarih aralığındaki TÜM olayları çeker — mağaza ölçeğinde
/// (günlük en fazla birkaç yüz olay) tek seferde çekip istemci tarafında
/// filtrelemek/gruplamak, web-genesis admin panelindeki ürün
/// istatistikleriyle AYNI "küçük veri, ekstra altyapı gerekmez" felsefesi
/// (bkz. admin-dashboard.js'teki statsFilteredProducts yorumu).
final analyticsEventsProvider =
    FutureProvider.autoDispose.family<List<AnalyticsEvent>, DateTimeRange>(
  (final ref, final range) async {
    final snap = await FirebaseFirestore.instance
        .collection('analytics_events')
        .where('createdAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(range.start))
        .where('createdAt',
            isLessThanOrEqualTo: Timestamp.fromDate(
                range.end.add(const Duration(days: 1, seconds: -1))))
        .orderBy('createdAt')
        .get();
    return snap.docs.map((final d) => AnalyticsEvent.fromMap(d.data())).toList();
  },
);
