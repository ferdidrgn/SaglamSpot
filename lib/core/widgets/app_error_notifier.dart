import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppErrorNotifier {
  static void show(
    final BuildContext context, {
    required final String message,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (final _) => _ErrorOverlay(
        message: message,
        onDismiss: () => entry.remove(),
      ),
    );

    overlay.insert(entry);

    Future.delayed(const Duration(seconds: 3), () {
      if (entry.mounted) entry.remove();
    });
  }
}

class _ErrorOverlay extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;

  const _ErrorOverlay({
    required this.message,
    required this.onDismiss,
  });

  @override
  Widget build(final BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.error.withOpacity(0.95),
                    AppColors.error.withOpacity(0.85),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.error.withOpacity(0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 16),
                  )
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onDismiss,
                    child: const Icon(Icons.close, color: Colors.white70),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
