import 'package:flutter/material.dart';
import '../util/responsive_utils.dart'; // Extension'lar için import

// Mixin kaldırıldı
class CustomSearchBar extends StatelessWidget {
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchTap;
  final TextEditingController? controller;

  const CustomSearchBar({
    super.key,
    this.onSearchTap,
    this.onSearchChanged,
    this.controller,
  });

  @override
  Widget build(final BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
          horizontal:
              context.responsive(mobile: 16.0, desktop: 40.0)), // Extension
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: _buildBorder(context, false),
          focusedBorder: _buildBorder(context, true),
          hintText: 'Eşya Ara...',
          hintStyle: TextStyle(
              fontSize:
                  context.responsive(mobile: 16.0, desktop: 18.0), // Extension
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface),
          contentPadding:
              EdgeInsets.all(context.responsive(mobile: 20.0, desktop: 25.0)),
          // Extension
          prefixIcon: IconButton(
            icon: Icon(Icons.search,
                color: Theme.of(context).colorScheme.primary),
            onPressed: onSearchTap,
          ),
          suffixIcon: controller?.text.isNotEmpty ?? false
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: () {
                    controller?.clear();
                    onSearchChanged?.call('');
                  },
                )
              : null,
        ),
        onTap: onSearchTap,
        onChanged: onSearchChanged,
      ),
    );
  }

  OutlineInputBorder _buildBorder(
      final BuildContext context, final bool isFocused) {
    final Color borderColor = Theme.of(context).brightness == Brightness.light
        ? (isFocused ? Colors.red.shade500 : Colors.red.shade200)
        : (isFocused ? Colors.red.shade200 : const Color(0xFFCF6679));

    return OutlineInputBorder(
      borderSide: BorderSide(color: borderColor, width: 3),
      borderRadius: BorderRadius.circular(10),
    );
  }
}
