import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../theme/app_colors.dart';

class CustomProductCard extends StatefulWidget {
  final Product product;
  final double? width;

  const CustomProductCard({
    super.key,
    required this.product,
    this.width,
  });

  @override
  State<CustomProductCard> createState() => _CustomProductCardState();
}

class _CustomProductCardState extends State<CustomProductCard> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  void _nextImage() {
    if (_currentImageIndex < widget.product.imagesUrl.length - 1) {
      setState(() {
        _currentImageIndex++;
      });
      _pageController.animateToPage(
        _currentImageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousImage() {
    if (_currentImageIndex > 0) {
      setState(() {
        _currentImageIndex--;
      });
      _pageController.animateToPage(
        _currentImageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showImageGallery(final BuildContext context, final int initialIndex) {
    showDialog(
      context: context,
      builder: (final context) => ImageGalleryDialog(
        images: widget.product.imagesUrl,
        initialIndex: initialIndex,
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {

    final hasMultipleImages = widget.product.imagesUrl.length > 1;

    return Container(
      width: widget.width, // DÜZELTİ: width -> widget.width
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image Gallery
          Stack(
            children: [
              // Image Container
              GestureDetector(
                onTap: () => _showImageGallery(context, _currentImageIndex),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    color: AppColors.background,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.product.imagesUrl.length,
                      onPageChanged: (final index) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                      itemBuilder: (final context, final index) {
                        return Image.network(
                          widget.product.imagesUrl[index],
                          fit: BoxFit.cover,
                          errorBuilder:
                              (final context, final error, final stackTrace) {
                            return Container(
                              color: AppColors.border,
                              child: const Icon(
                                Icons.photo_outlined,
                                color: AppColors.textSecondary,
                                size: 48,
                              ),
                            );
                          },
                          loadingBuilder: (final context, final child,
                              final loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: AppColors.background,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  color: AppColors.primary,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Navigation Arrows (only show if multiple images)
              if (hasMultipleImages) ...[
                // Left Arrow
                Positioned(
                  left: 8,
                  top: 0,
                  bottom: 0,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: _previousImage,
                      child: Container(
                        width: 32,
                        height: 32,
                        margin: const EdgeInsets.symmetric(vertical: 84),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.chevron_left,
                          color: _currentImageIndex > 0
                              ? AppColors.primary
                              : AppColors.textTertiary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),

                // Right Arrow
                Positioned(
                  right: 8,
                  top: 0,
                  bottom: 0,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: _nextImage,
                      child: Container(
                        width: 32,
                        height: 32,
                        margin: const EdgeInsets.symmetric(vertical: 84),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.chevron_right,
                          color: _currentImageIndex <
                                  widget.product.imagesUrl.length - 1
                              ? AppColors.primary
                              : AppColors.textTertiary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],

              // Image Counter
              if (hasMultipleImages)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_currentImageIndex + 1}/${widget.product.imagesUrl.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

              // Image Indicators (Dots)
              if (hasMultipleImages)
                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.product.imagesUrl.length,
                      // DÜZELTİ: images -> imagesUrl
                      (final index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentImageIndex = index;
                          });
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentImageIndex == index
                                ? AppColors.primary
                                : Colors.white.withOpacity(0.7),
                            border: _currentImageIndex == index
                                ? null
                                : Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Product Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name, // DÜZELTİ: product -> widget.product
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.product.desc, // DÜZELTİ: product -> widget.product
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.product.price} TL',
                      // DÜZELTİ: product -> widget.product
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: widget.product
                                .isSold // DÜZELTİ: product -> widget.product
                            ? AppColors.error.withOpacity(0.1)
                            : AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        widget.product.isSold ? 'Satıldı' : 'Stokta',
                        // DÜZELTİ: product -> widget.product
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: widget.product
                                  .isSold // DÜZELTİ: product -> widget.product
                              ? AppColors.error
                              : AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Image Gallery Dialog for Full Screen View
class ImageGalleryDialog extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const ImageGalleryDialog({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<ImageGalleryDialog> createState() => _ImageGalleryDialogState();
}

class _ImageGalleryDialogState extends State<ImageGalleryDialog> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextImage() {
    if (_currentIndex < widget.images.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousImage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          // Background Overlay
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              color: Colors.black.withOpacity(0.8),
            ),
          ),

          // Close Button
          Positioned(
            top: 40,
            right: 40,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),

          // Image Gallery
          Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9,
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: widget.images.length,
                    onPageChanged: (final index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (final context, final index) {
                      return InteractiveViewer(
                        panEnabled: true,
                        scaleEnabled: true,
                        minScale: 0.5,
                        maxScale: 3.0,
                        child: Image.network(
                          widget.images[index],
                          fit: BoxFit.contain,
                          errorBuilder:
                              (final context, final error, final stackTrace) {
                            return Container(
                              color: AppColors.border,
                              child: const Icon(
                                Icons.photo_outlined,
                                color: AppColors.textSecondary,
                                size: 64,
                              ),
                            );
                          },
                          loadingBuilder: (final context, final child,
                              final loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                color: AppColors.primary,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),

                  // Navigation Arrows
                  if (widget.images.length > 1) ...[
                    // Left Arrow
                    Positioned(
                      left: 20,
                      top: 0,
                      bottom: 0,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: _previousImage,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.chevron_left,
                              color: _currentIndex > 0
                                  ? Colors.white
                                  : Colors.white54,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Right Arrow
                    Positioned(
                      right: 20,
                      top: 0,
                      bottom: 0,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: _nextImage,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.chevron_right,
                              color: _currentIndex < widget.images.length - 1
                                  ? Colors.white
                                  : Colors.white54,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],

                  // Image Counter
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_currentIndex + 1}/${widget.images.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
