import 'package:flutter/material.dart';

/// Named width breakpoints for the app's three layout tiers, shared by
/// [Responsive] so screens don't hardcode their own thresholds.
class AppBreakpoints {
  AppBreakpoints._();

  /// Below this width: phone layout.
  static const double tablet = 650;

  /// From [tablet] up to (not including) this width: tablet layout.
  /// At or above: desktop/laptop layout.
  static const double desktop = 1100;
}

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;

  /// Optional — screens that haven't been given a dedicated desktop layout
  /// yet fall back to [tablet] at desktop widths instead of stretching the
  /// phone layout, which tends to look worse on a laptop-wide window.
  final Widget? desktop;

  const Responsive({
    super.key,
    required this.mobile,
    required this.tablet,
    this.desktop,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < AppBreakpoints.tablet;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= AppBreakpoints.tablet && width < AppBreakpoints.desktop;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= AppBreakpoints.desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        if (width >= AppBreakpoints.desktop) {
          return desktop ?? tablet;
        } else if (width >= AppBreakpoints.tablet) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}
