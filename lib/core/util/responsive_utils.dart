import 'package:flutter/material.dart';

/// Responsive tasarım için merkezi utility sınıfı
/// Clean Architecture ve SOLID prensipleriyle tasarlanmıştır
class ResponsiveUtils {
  ResponsiveUtils._(); // Private constructor - utility class

  // Breakpoint sabitleri
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  /// Cihaz tipi kontrolü
  static bool isMobile(final BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  static bool isTablet(final BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(final BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint;

  static bool isLargeDesktop(final BuildContext context) =>
      MediaQuery.of(context).size.width >= desktopBreakpoint;

  /// Cihaz tipine göre değer döndüren generic metot
  static T getValueForDevice<T>(
    final BuildContext context, {
    required final T mobile,
    final T? tablet,
    required final T desktop,
    final T? largeDesktop,
  }) {
    if (isLargeDesktop(context)) return largeDesktop ?? desktop;
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet ?? desktop;
    return mobile;
  }

  /// Grid için cross axis count
  static int getGridCrossAxisCount(final BuildContext context) {
    return getValueForDevice(
      context,
      mobile: 2,
      tablet: 3,
      desktop: 4,
      largeDesktop: 5,
    );
  }

  /// Grid spacing
  static double getGridSpacing(final BuildContext context) {
    return getValueForDevice(
      context,
      mobile: 8.0,
      tablet: 12.0,
      desktop: 16.0,
      largeDesktop: 20.0,
    );
  }

  /// Card aspect ratio
  static double getCardAspectRatio(final BuildContext context) {
    return getValueForDevice(
      context,
      mobile: 0.72,
      tablet: 0.78,
      desktop: 0.82,
      largeDesktop: 0.85,
    );
  }

  /// Card padding
  static EdgeInsets getCardPadding(final BuildContext context) {
    return EdgeInsets.all(
      getValueForDevice(
        context,
        mobile: 8.0,
        tablet: 10.0,
        desktop: 12.0,
        largeDesktop: 14.0,
      ),
    );
  }

  /// Card margin
  static EdgeInsets getCardMargin(final BuildContext context) {
    return EdgeInsets.all(
      getValueForDevice(
        context,
        mobile: 4.0,
        tablet: 6.0,
        desktop: 6.0,
      ),
    );
  }

  /// Border radius
  static double getBorderRadius(final BuildContext context,
      {final double scale = 1.0}) {
    return getValueForDevice(
          context,
          mobile: 12.0,
          tablet: 14.0,
          desktop: 16.0,
        ) *
        scale;
  }

  /// Icon size
  static double getIconSize(final BuildContext context,
      {final double scale = 1.0}) {
    return getValueForDevice(
          context,
          mobile: 16.0,
          tablet: 18.0,
          desktop: 20.0,
        ) *
        scale;
  }

  /// Font sizes - Semantic naming
  static double getTitleFontSize(final BuildContext context) {
    return getValueForDevice(
      context,
      mobile: 12.0,
      tablet: 13.0,
      desktop: 14.0,
    );
  }

  static double getBodyFontSize(final BuildContext context) {
    return getValueForDevice(
      context,
      mobile: 10.0,
      tablet: 11.0,
      desktop: 12.0,
    );
  }

  static double getCaptionFontSize(final BuildContext context) {
    return getValueForDevice(
      context,
      mobile: 8.0,
      tablet: 9.0,
      desktop: 10.0,
    );
  }

  static double getPriceFontSize(final BuildContext context) {
    return getValueForDevice(
      context,
      mobile: 13.0,
      tablet: 14.0,
      desktop: 15.0,
    );
  }

  /// Image height for cards
  static double getCardImageHeight(final BuildContext context) {
    return getValueForDevice(
      context,
      mobile: 120.0,
      tablet: 140.0,
      desktop: 160.0,
      largeDesktop: 180.0,
    );
  }

  /// Badge sizes
  static EdgeInsets getBadgePadding(final BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: getValueForDevice(context, mobile: 6.0, desktop: 8.0),
      vertical: getValueForDevice(context, mobile: 2.0, desktop: 3.0),
    );
  }

  /// Content max width (for centering on large screens)
  static double getMaxContentWidth(final BuildContext context) {
    return getValueForDevice(
      context,
      mobile: double.infinity,
      desktop: 1400.0,
      largeDesktop: 1600.0,
    );
  }

  /// Screen padding
  static EdgeInsets getScreenPadding(final BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: getValueForDevice(
        context,
        mobile: 12.0,
        tablet: 20.0,
        desktop: 32.0,
        largeDesktop: 48.0,
      ),
      vertical: getValueForDevice(
        context,
        mobile: 12.0,
        desktop: 16.0,
      ),
    );
  }

  /// Chip/Tag sizes
  static double getChipHeight(final BuildContext context) {
    return getValueForDevice(
      context,
      mobile: 24.0,
      tablet: 26.0,
      desktop: 28.0,
    );
  }

  /// Button sizes
  static double getButtonHeight(final BuildContext context) {
    return getValueForDevice(
      context,
      mobile: 40.0,
      tablet: 44.0,
      desktop: 48.0,
    );
  }

  /// Shadow blur radius
  static double getShadowBlurRadius(final BuildContext context) {
    return getValueForDevice(
      context,
      mobile: 8.0,
      tablet: 10.0,
      desktop: 12.0,
    );
  }
}
