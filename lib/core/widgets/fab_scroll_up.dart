import 'package:flutter/material.dart';

class ScrollUpButton extends StatelessWidget {
  final ScrollController scrollController;
  final double showOffset;

  const ScrollUpButton({
    super.key,
    required this.scrollController,
    this.showOffset = 300,
  });

  @override
  Widget build(final BuildContext context) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (final _, final __) {
        final visible =
            scrollController.hasClients && scrollController.offset > showOffset;

        return AnimatedPositioned(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          right: 24,
          bottom: visible ? 24 : -80,
          child: FloatingActionButton(
            elevation: 6,
            backgroundColor: Colors.black,
            onPressed: () {
              scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeOutCubic,
              );
            },
            child: const Icon(Icons.keyboard_arrow_up),
          ),
        );
      },
    );
  }
}
