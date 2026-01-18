import 'package:flutter/material.dart';
import '../extentions/app_context_ui_extension.dart';
import '../theme/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? action;

  const SectionHeader(
      {super.key, required this.title, required this.subtitle, this.action});

  @override
  Widget build(final BuildContext context) {
    final bool mobile = context.isMobile;

    final titleSection = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: context.responsive(
                      mobile: 22.0, desktop: 28.0), // Extension
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: TextStyle(
                  fontSize: context.responsive(
                      mobile: 14.0, desktop: 16.0), // Extension
                  color: AppColors.textSecondary)),
        ],
      ),
    );

    if (mobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [titleSection]),
          if (action != null) ...[
            const SizedBox(height: 12),
            action!,
          ],
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          titleSection,
          if (action != null) action!,
        ],
      );
    }
  }
}
