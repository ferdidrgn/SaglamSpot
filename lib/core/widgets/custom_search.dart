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
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.red.shade200
                    : const Color(0xFFCF6679),
                width: 3,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.red.shade500
                    : Colors.red.shade200,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: 'Eşya Ara...',
            hintStyle: TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            prefixIcon: IconButton(
              icon: Icon(
                  Icons.youtube_searched_for,
                  color: Theme.of(context).colorScheme.error
              ),
              onPressed: onSearchTap,
            ),
            suffixIcon: controller?.text.isNotEmpty ?? false ? IconButton(
              icon: Icon(
                Icons.clear,
                color: Theme.of(context).colorScheme.error,
              ),
              onPressed: () {
                controller?.clear();
                onSearchChanged?.call('');
              },
            ) : null,
          ),
          onTap: onSearchTap,
          onChanged: onSearchChanged,
        )
    );
  }
}