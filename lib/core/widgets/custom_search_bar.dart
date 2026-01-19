import 'package:flutter/material.dart';
import '../common/extentions/app_context_ui_extension.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearch;

  const CustomSearchBar(
      {super.key, required this.controller, required this.onSearch});

  @override
  Widget build(final BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.08),
      margin: EdgeInsets.symmetric(
        horizontal: context.responsive(mobile: 24.0, desktop: 60.0),
        vertical: 10,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        height: 70,
        child: TextField(
          controller: controller,
          textInputAction: TextInputAction.search,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),

          /// ✅ ENTER
          onSubmitted: (final value) {
            final query = value.trim();
            if (query.isEmpty) return;
            onSearch(query);
          },

          decoration: InputDecoration(
            hintText: "Eviniz için ne aramıştınız?",
            hintStyle: const TextStyle(
              color: Colors.black26,
              fontSize: 18,
            ),

            prefixIcon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                Icons.search_rounded,
                size: 28,
                color: Colors.black87,
              ),
            ),

            /// ✅ Sağ ikon = bilinçli arama
            suffixIcon: IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
              onPressed: () {
                final query = controller.text.trim();
                if (query.isEmpty) return;
                onSearch(query);
              },
            ),

            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 22),
          ),
        ),
      ),
    );
  }
}
