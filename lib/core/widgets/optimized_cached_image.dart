import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:saglamspot/core/widgets/shimmer_components.dart';

class OptimizedCachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final bool isCircular;
  final Widget Function(BuildContext, String, dynamic)? errorBuilder;

  /// Decode boyutu çarpanı — yakınlaştırılabilen (InteractiveViewer)
  /// tam ekran galeride >1 verilir ki zoom'da görsel bulanıklaşmasın.
  final double decodeScale;

  const OptimizedCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 8.0,
    this.isCircular = false,
    this.errorBuilder,
    this.decodeScale = 1.0,
  });

  /// ✅ Provider Üretici (Precache işlemleri için)
  static CachedNetworkImageProvider provider(
    final String imageUrl, {
    required final BuildContext context,
    final double? width,
    final double? height,
  }) =>
      CachedNetworkImageProvider(
        imageUrl,
        maxWidth: _calculateCacheSize(context, width),
        maxHeight: _calculateCacheSize(context, height),
      );

  @override
  Widget build(final BuildContext context) {
    // Eğer yuvarlak ise yarıçapı hesapla, değilse normal radius kullan
    final double effectiveRadius =
        isCircular ? (height ?? width ?? 50) / 2 : borderRadius;

    // Genişlik/yükseklik verilmediğinde (ör. ürün kartında Stack'i
    // dolduran görsel) önceden memCache boyutu hesaplanamıyordu ve
    // telefon fotoğrafları TAM çözünürlükte (12 MP ≈ 48 MB RAM/görsel)
    // decode ediliyordu — düşük segment Android'lerde kaydırma takılması
    // ve bellek baskısının bir numaralı nedeni. Artık widget kendi
    // alanını ölçüp o boyutta decode ettiriyor.
    if (width == null || height == null) {
      return LayoutBuilder(
        builder: (final context, final constraints) => _buildImage(
          context,
          effectiveRadius,
          _decodeWidth(
            context,
            width ?? constraints.maxWidth,
            height ?? constraints.maxHeight,
            decodeScale,
          ),
        ),
      );
    }
    return _buildImage(
        context, effectiveRadius, _decodeWidth(context, width, height, decodeScale));
  }

  Widget _buildImage(final BuildContext context, final double effectiveRadius,
      final int? decodeWidth) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(effectiveRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        // Animasyon Ayarları
        fadeInDuration: const Duration(milliseconds: 300),
        fadeInCurve: Curves.easeOut,

        // Bellek Optimizasyonu: yalnızca GENİŞLİK veriliyor — ikisi birden
        // verilince ResizeImage en-boy oranını bozuyordu. BoxFit.cover için
        // kutunun uzun kenarı baz alınır (bkz. _decodeWidth).
        memCacheWidth: decodeWidth,

        // Yükleniyor (Shimmer)
        placeholder: (final context, final url) => ShimmerLoading(
          width: width ?? double.infinity,
          height: height ?? double.infinity,
          borderRadius: effectiveRadius, // Shimmer da aynı şekli alsın
          isCircular: isCircular,
        ),

        // Hata Durumu (Eski kodunuzdaki tasarıma sadık kalındı)
        errorWidget: errorBuilder ??
            (final context, final url, final error) {
              final isDarkMode =
                  Theme.of(context).brightness == Brightness.dark;
              return Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.grey[800]!.withOpacity(0.5)
                      : Colors.grey[200]!.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(effectiveRadius),
                ),
                child: Center(
                  child: Icon(
                    Icons.broken_image_outlined, // Veya photo_outlined
                    color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                    size: (width != null && width! < 50) ? 20 : 24,
                  ),
                ),
              );
            },
      ),
    );
  }

  /// Decode genişliği: kutunun uzun kenarı × piksel yoğunluğu (cover'da
  /// dikey bir kutuya yatay fotoğraf da bulanıklaşmadan oturabilsin diye),
  /// DPR 3 ile ve 2048 px ile sınırlı.
  static int? _decodeWidth(
      final BuildContext context, final double? width, final double? height,
      [final double scale = 1.0]) {
    final w = (width != null && width.isFinite) ? width : null;
    final h = (height != null && height.isFinite) ? height : null;
    if (w == null && h == null) return null;
    final side = w == null ? h! : (h == null ? w : (w > h ? w : h));
    if (side <= 0) return null;
    final dpr = MediaQuery.devicePixelRatioOf(context).clamp(1.0, 3.0);
    return (side * dpr * scale).round().clamp(1, 2048);
  }

  /// Cache boyutunu hesaplayan yardımcı metot
  static int? _calculateCacheSize(
      final BuildContext context, final double? size) {
    if (size == null || size == double.infinity) return null;
    // Cihazın piksel yoğunluğunu al (Retina ekranlar için x2, x3 gibi)
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    // Biraz tolerans ekleyerek (cache kalitesi düşmesin diye) int'e çevir
    return (size * devicePixelRatio).round();
  }
}
