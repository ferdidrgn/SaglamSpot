import 'package:flutter/material.dart';
import 'package:saglamspot/core/theme/app_colors.dart';
import 'package:saglamspot/core/util/responsive_utils.dart';

class WebOnboardingScreen extends StatelessWidget {
  const WebOnboardingScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F5),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1440),
          child: context.isDesktop
              ? _buildDesktopLayout(context)
              : _buildMobileLayout(context),
        ),
      ),
    );
  }

  // DESKTOP LAYOUT (Side by side)
  Widget _buildDesktopLayout(final BuildContext context) {
    return Row(
      children: [
        // Left side - Hero image
        Expanded(
          flex: 6,
          child: _buildHeroSection(context),
        ),
        // Right side - Content
        Expanded(
          flex: 4,
          child: _buildContentSection(context),
        ),
      ],
    );
  }

  // MOBILE/TABLET LAYOUT (Stacked)
  Widget _buildMobileLayout(final BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: context.hp(60),
            child: _buildHeroSection(context),
          ),
          _buildContentSection(context),
        ],
      ),
    );
  }

  Widget _buildHeroSection(final BuildContext context) {
    return Container(
      padding: context.pagePadding,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background watermark
          Opacity(
            opacity: 0.04,
            child: Text(
              'Stylish',
              style: TextStyle(
                fontSize: context.responsive(
                  mobile: 80.0,
                  tablet: 120.0,
                  desktop: 160.0,
                  largeDesktop: 200.0,
                ),
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
          ),

          // Main product image
          Container(
            width: context.responsive(
              mobile: 280.0,
              tablet: 350.0,
              desktop: 450.0,
              largeDesktop: 550.0,
            ),
            height: context.responsive(
              mobile: 280.0,
              tablet: 350.0,
              desktop: 450.0,
              largeDesktop: 550.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(250),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.15),
                  blurRadius: 80,
                  offset: const Offset(0, 40),
                ),
              ],
            ),
            child: Icon(
              Icons.chair_rounded,
              size: context.responsive(
                mobile: 160.0,
                tablet: 200.0,
                desktop: 260.0,
                largeDesktop: 320.0,
              ),
              color: AppColors.primary.withOpacity(0.3),
            ),
          ),

          // Floating labels
          Positioned(
            top: context.responsive(mobile: 40.0, desktop: 80.0),
            left: context.responsive(mobile: 20.0, desktop: 40.0),
            child: _buildFloatingLabel('Pure Comfort', AppColors.accent),
          ),
          Positioned(
            right: context.responsive(mobile: 20.0, desktop: 40.0),
            top: context.responsive(mobile: 100.0, desktop: 140.0),
            child: _buildFloatingLabel('Luxury Sit', AppColors.primary),
          ),
          Positioned(
            bottom: context.responsive(mobile: 80.0, desktop: 120.0),
            left: context.responsive(mobile: 40.0, desktop: 60.0),
            child: _buildFloatingLabel('Elegance Chair', AppColors.secondary),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(final BuildContext context) {
    return Container(
      padding: context.pagePadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: context.isDesktop
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          // Title
          RichText(
            textAlign: context.isDesktop ? TextAlign.left : TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: context.h1Size,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
              children: const [
                TextSpan(text: 'Design Your\nPerfect '),
                TextSpan(
                  text: 'Furniture\nSpace',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                TextSpan(text: ' 💡'),
              ],
            ),
          ),

          SizedBox(height: context.spacing * 2),

          // Subtitle
          Text(
            'Modern mobilyalarla yaşam alanınızı dönüştürün. '
            'Kaliteli, şık ve uygun fiyatlı mobilyalar.',
            style: TextStyle(
              fontSize: context.bodySize,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            textAlign: context.isDesktop ? TextAlign.left : TextAlign.center,
          ),

          SizedBox(height: context.spacingLarge),

          // CTA Buttons
          SizedBox(
            width: context.isDesktop ? 400 : double.infinity,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      // Navigate to home
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical:
                            context.responsive(mobile: 16.0, desktop: 20.0),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(context.borderRadius(0.7)),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: context.bodySize + 2,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      padding: EdgeInsets.symmetric(
                        vertical:
                            context.responsive(mobile: 16.0, desktop: 20.0),
                      ),
                      side: const BorderSide(color: AppColors.border, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(context.borderRadius(0.7)),
                      ),
                    ),
                    child: Text(
                      'Explore Products',
                      style: TextStyle(
                        fontSize: context.bodySize + 2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: context.spacingLarge),

          // Page Indicator
          Row(
            mainAxisAlignment: context.isDesktop
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: List.generate(3, (final index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: index == 0 ? 32 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: index == 0 ? Colors.black : Colors.black26,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingLabel(final String text, final Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
