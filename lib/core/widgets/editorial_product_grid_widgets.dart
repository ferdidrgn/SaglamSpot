import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// EDİTORYAL KATALOG DİLİ — "Sıfır Ürünler" ve "İkinci El" sayfalarına
/// özel, geri kalan uygulamadan (CustomProductCard / DynamicCategoryChips /
/// ProductListCard) bilinçli olarak AYRIŞTIRILMIŞ bir görsel dil: renkli
/// gradyanlı çip yerine düz metin sekmeler, ağır gölge yerine ince tel
/// kenarlık, yuvarlatılmış rozet yerine tek renkli nokta+etiket. Marka
/// renkleri (AppColors) korunuyor — sadece ŞEKİL DİLİ değişiyor.
///
/// Saf beyaz/boş bir sayfa "taslak kağıdı" gibi durmasın diye — çok soluk,
/// büyük mobilya silüetlerinden oluşan sanatsal bir doku katmanı. İçerik
/// DEĞİL, saf dekorasyon: erişilebilirlik ağacından ve dokunma
/// olaylarından hariç tutulur.
class FurnitureMotifBackdrop extends StatelessWidget {
  final bool dense;

  const FurnitureMotifBackdrop({super.key, this.dense = false});

  @override
  Widget build(final BuildContext context) => ExcludeSemantics(
        child: IgnorePointer(
          child: Stack(
            children: [
              Positioned(
                top: -36,
                right: -24,
                child: Transform.rotate(
                  angle: -0.16,
                  child: Icon(Icons.weekend_rounded,
                      size: dense ? 120 : 200,
                      color: AppColors.textPrimary.withOpacity(0.045)),
                ),
              ),
              Positioned(
                bottom: -18,
                left: -28,
                child: Transform.rotate(
                  angle: 0.14,
                  child: Icon(Icons.local_florist_rounded,
                      size: dense ? 70 : 130,
                      color: AppColors.accentDark.withOpacity(0.07)),
                ),
              ),
              if (!dense)
                Positioned(
                  top: 54,
                  right: 210,
                  child: Transform.rotate(
                    angle: 0.22,
                    child: Icon(Icons.light_rounded,
                        size: 64, color: AppColors.textTertiary.withOpacity(0.09)),
                  ),
                ),
              if (!dense)
                Positioned(
                  bottom: 24,
                  right: 40,
                  child: Icon(Icons.table_bar_rounded,
                      size: 80, color: AppColors.textTertiary.withOpacity(0.06)),
                ),
            ],
          ),
        ),
      );
}

/// İnce, tekrarlayan mobilya glifi şeridi — bölümler arası kalın çizgi
/// yerine kumaş desenine benzeyen sanatsal bir ayraç.
class FurnitureMotifDivider extends StatelessWidget {
  const FurnitureMotifDivider({super.key});

  static const _glyphs = [
    Icons.chair_rounded,
    Icons.local_florist_outlined,
    Icons.light_rounded,
    Icons.table_bar_rounded,
  ];

  @override
  Widget build(final BuildContext context) => ExcludeSemantics(
        child: SizedBox(
          height: 22,
          child: LayoutBuilder(
            builder: (final context, final constraints) {
              const step = 46.0;
              final count = (constraints.maxWidth / step).ceil() + 1;
              return ClipRect(
                child: Row(
                  children: List.generate(
                    count,
                    (final i) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 11),
                      child: Icon(_glyphs[i % _glyphs.length],
                          size: 13, color: AppColors.border),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
}
