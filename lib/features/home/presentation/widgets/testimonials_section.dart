import 'package:flutter/material.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(final BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    final testimonials = _testimonials(context);

    return SliverPadding(
      padding:
          EdgeInsets.symmetric(horizontal: isMobile ? 20 : 60, vertical: 26),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.testimonialsHeading,
                style: TextStyle(
                    fontFamily: 'Fraunces',
                    fontSize: context.h2Size,
                    fontWeight: FontWeight.w600,
                    color: context.primaryColor)),
            const SizedBox(height: 4),
            Container(height: 3, width: 40, color: AppColors.accent),
            const SizedBox(height: 8),
            Text(
              context.l10n.testimonialsSubheading,
              style: TextStyle(
                  color: context.primaryColor.withOpacity(0.5),
                  fontSize: context.captionSize),
            ),
            const SizedBox(height: 32),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 1 : 3,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                mainAxisExtent: 240,
              ),
              itemCount: testimonials.length,
              itemBuilder: (final context, final index) =>
                  _TestimonialCard(data: testimonials[index]),
            ),
          ],
        ),
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final _Testimonial data;

  const _TestimonialCard({required this.data});

  @override
  Widget build(final BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 10)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(
                5,
                (final i) => Icon(
                  i < data.rating
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  color: AppColors.accent,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: Text(
                data.comment,
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 14, height: 1.5),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Divider(height: 24),
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.secondary,
                  child: Text(
                    data.name.characters.first,
                    style: TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(data.location,
                          style: TextStyle(
                              color: AppColors.textTertiary, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

class _Testimonial {
  final String name;
  final String location;
  final String comment;
  final int rating;

  const _Testimonial({
    required this.name,
    required this.location,
    required this.comment,
    required this.rating,
  });
}

List<_Testimonial> _testimonials(final BuildContext context) => [
      _Testimonial(
        name: 'Elif Yıldız',
        location: 'İçerenköy, Ataşehir',
        comment: context.l10n.testimonial1Comment,
        rating: 5,
      ),
      _Testimonial(
        name: 'Mehmet Kaya',
        location: 'Kayışdağı, Ataşehir',
        comment: context.l10n.testimonial2Comment,
        rating: 5,
      ),
      _Testimonial(
        name: 'Ayşe Demir',
        location: 'Küçükbakkalköy, Ataşehir',
        comment: context.l10n.testimonial3Comment,
        rating: 4,
      ),
      _Testimonial(
        name: 'Burak Şahin',
        location: 'Bostancı, Kadıköy',
        comment: context.l10n.testimonial4Comment,
        rating: 5,
      ),
      _Testimonial(
        name: 'Zeynep Arslan',
        location: 'Fındıklı, Ataşehir',
        comment: context.l10n.testimonial5Comment,
        rating: 5,
      ),
      _Testimonial(
        name: 'Can Öztürk',
        location: 'Kozyatağı, Kadıköy',
        comment: context.l10n.testimonial6Comment,
        rating: 4,
      ),
    ];
