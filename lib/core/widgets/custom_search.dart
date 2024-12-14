import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: _buildBorder(context, false),
          focusedBorder: _buildBorder(context, true),
          hintText: 'Eşya Ara...',
          hintStyle: TextStyle(
            fontSize: 18,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          prefixIcon: IconButton(
            icon: Icon(
              Icons.search, // Arama ikonu
              color: Theme.of(context).colorScheme.primary,
            ),
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

  OutlineInputBorder _buildBorder(BuildContext context, bool isFocused) {
    Color borderColor = Theme.of(context).brightness == Brightness.light
        ? (isFocused ? Colors.red.shade500 : Colors.red.shade200)
        : (isFocused ? Colors.red.shade200 : const Color(0xFFCF6679));

    return OutlineInputBorder(
      borderSide: BorderSide(
        color: borderColor,
        width: 3,
      ),
      borderRadius: BorderRadius.circular(10),
    );
  }
}