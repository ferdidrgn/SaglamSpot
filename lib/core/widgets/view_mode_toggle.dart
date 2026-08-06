import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/product_view_mode_provider.dart';
import '../theme/app_colors.dart';

/// Referans görseldeki gibi: yuvarlak hatlı, iki ikonlu (ızgara/liste)
/// segment kontrolü. Seçili olan koyu dolgu, diğeri düz ikon.
class ViewModeToggle extends ConsumerWidget {
  const ViewModeToggle({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final mode = ref.watch(productViewModeProvider);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _iconButton(
            icon: Icons.grid_view_rounded,
            isSelected: mode == ProductViewMode.grid,
            onTap: () =>
                ref.read(productViewModeProvider.notifier).set(ProductViewMode.grid),
          ),
          const SizedBox(width: 4),
          _iconButton(
            icon: Icons.view_list_rounded,
            isSelected: mode == ProductViewMode.list,
            onTap: () =>
                ref.read(productViewModeProvider.notifier).set(ProductViewMode.list),
          ),
        ],
      ),
    );
  }

  Widget _iconButton(
      {required final IconData icon,
      required final bool isSelected,
      required final VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 40,
        height: 36,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isSelected ? Colors.white : AppColors.textTertiary,
        ),
      ),
    );
  }
}
