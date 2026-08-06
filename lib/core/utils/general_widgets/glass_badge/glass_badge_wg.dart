import 'package:flutter/material.dart';

class GlassBadgeWg extends StatelessWidget {
  final Widget child;
  final bool isCircle;

  const GlassBadgeWg({super.key, required this.child, this.isCircle = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isCircle ? 8 : 6).copyWith(left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: Colors.black.withValues(alpha: 0.08),
          ),
        ],
      ),
      child: child,
    );
  }
}
