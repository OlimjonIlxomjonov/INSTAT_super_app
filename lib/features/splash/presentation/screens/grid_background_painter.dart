import 'package:flutter/material.dart';

class GridBackgroundPainter extends CustomPainter {
  GridBackgroundPainter({
    required this.backgroundColor,
    required this.lineColor,
    this.cellSize = 44, // tweak to match Figma
    this.majorEvery = 4, // every N cells draw a stronger line
    this.minorOpacity = 0.08, // subtle lines
    this.majorOpacity = 0.14, // slightly stronger lines
    this.strokeWidth = 1.0,
  });

  final Color backgroundColor;
  final Color lineColor;

  final double cellSize;
  final int majorEvery;

  final double minorOpacity;
  final double majorOpacity;

  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    // Fill background
    final bgPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Offset.zero & size, bgPaint);

    // Grid paints
    final minorPaint = Paint()
      ..color = lineColor.withValues(alpha: minorOpacity)
      ..strokeWidth = strokeWidth;

    final majorPaint = Paint()
      ..color = lineColor.withValues(alpha: majorOpacity)
      ..strokeWidth = strokeWidth;

    // Draw vertical lines
    double x = 0;
    int col = 0;
    while (x <= size.width) {
      final p = (majorEvery > 0 && col % majorEvery == 0)
          ? majorPaint
          : minorPaint;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
      x += cellSize;
      col++;
    }

    // Draw horizontal lines
    double y = 0;
    int row = 0;
    while (y <= size.height) {
      final p = (majorEvery > 0 && row % majorEvery == 0)
          ? majorPaint
          : minorPaint;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
      y += cellSize;
      row++;
    }

    // Optional: subtle vignette to match “designed” look
    // If you don’t want this, delete this block.
    final vignette = Paint()
      ..shader =
          RadialGradient(
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.10)],
            stops: const [0.65, 1.0],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width / 2, size.height / 2),
              radius: size.longestSide * 0.75,
            ),
          );
    canvas.drawRect(Offset.zero & size, vignette);
  }

  @override
  bool shouldRepaint(covariant GridBackgroundPainter oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.cellSize != cellSize ||
        oldDelegate.majorEvery != majorEvery ||
        oldDelegate.minorOpacity != minorOpacity ||
        oldDelegate.majorOpacity != majorOpacity ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
