import 'package:flutter/material.dart';

class AppBreakpoints {
  AppBreakpoints._();

  static const double tablet = 650;

  static const double desktop = 1100;
}

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;

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
