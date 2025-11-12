import 'package:flutter/material.dart';
import '../util/responsive_utils.dart';

class CustomSearchBar extends StatelessWidget with ResponsiveUtils {
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
          horizontal: getValueForDevice(context, mobile: 16, desktop: 40)),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: _buildBorder(context, false),
          focusedBorder: _buildBorder(context, true),
          hintText: 'Eşya Ara...',
          hintStyle: TextStyle(
              fontSize: getValueForDevice(context, mobile: 16, desktop: 18),
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface),
          contentPadding: EdgeInsets.all(
              getValueForDevice(context, mobile: 20, desktop: 25)),
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
