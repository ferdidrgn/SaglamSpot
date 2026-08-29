import 'package:flutter/material.dart';

/// Bir üründe birden fazla fotoğraf varsa, kart üzerinde ok butonlarıyla
/// (< / >) fotoğraflar arasında geçiş yapılmasını sağlar. Tek fotoğraflı
/// (veya hiç fotoğrafı olmayan) ürünlerde oklar ve nokta göstergesi hiç
/// gösterilmez — kart normal, sabit görselli haliyle kalır.
///
/// Ok butonları kendi [InkWell]'i içinde olduğu için, kartı saran dış
/// `GestureDetector`'ın "ürün detayına git" davranışını tetiklemez.
class ProductImageSwitcher extends StatefulWidget {
  const ProductImageSwitcher({
    super.key,
    required this.images,
    required this.imageBuilder,
    required this.fallback,
    this.dotsAtTop = false,
  });

  final List<String> images;
  final Widget Function(String imageUrl) imageBuilder;
  final Widget fallback;

  /// Nokta göstergesinin görsel bölümünün üstünde mi altında mı
  /// gösterileceği — kartın zaten alt kısmında başka bir katman (örn. hover
  /// eylemi) varsa `true` verilir.
  final bool dotsAtTop;

  @override
  State<ProductImageSwitcher> createState() => _ProductImageSwitcherState();
}

class _ProductImageSwitcherState extends State<ProductImageSwitcher> {
  int _index = 0;

  @override
  void didUpdateWidget(covariant final ProductImageSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.images != oldWidget.images) _index = 0;
  }

  void _go(final int delta) {
    final count = widget.images.length;
    if (count < 2) return;
    // Dart'ta int % pozitif bölende her zaman negatif olmayan sonuç verir,
    // bu yüzden -1 % count gibi durumlar da doğrudan doğru şekilde sarılır.
    setState(() => _index = (_index + delta) % count);
  }

  @override
  Widget build(final BuildContext context) {
    if (widget.images.isEmpty) return widget.fallback;

    final hasMultiple = widget.images.length > 1;

    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: KeyedSubtree(
            key: ValueKey(_index),
            child: widget.imageBuilder(widget.images[_index]),
          ),
        ),
        if (hasMultiple) ...[
          Positioned(
            left: 6,
            top: 0,
            bottom: 0,
            child: Center(
              child: _ArrowButton(
                icon: Icons.chevron_left_rounded,
                onTap: () => _go(-1),
              ),
            ),
          ),
          Positioned(
            right: 6,
            top: 0,
            bottom: 0,
            child: Center(
              child: _ArrowButton(
                icon: Icons.chevron_right_rounded,
                onTap: () => _go(1),
              ),
            ),
          ),
          if (widget.images.length <= 10)
            Positioned(
              top: widget.dotsAtTop ? 10 : null,
              bottom: widget.dotsAtTop ? null : 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < widget.images.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: i == _index ? 12 : 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color:
                            Colors.white.withOpacity(i == _index ? 0.95 : 0.5),
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 2),
                        ],
                      ),
                    ),
                ],
              ),
            ),
        ],
      ],
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) => Material(
        color: Colors.white.withOpacity(0.85),
        shape: const CircleBorder(),
        elevation: 1,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(icon, size: 20, color: const Color(0xFF1A1A1A)),
          ),
        ),
      );
}
