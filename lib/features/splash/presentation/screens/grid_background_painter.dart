import 'dart:math' as math;

import 'package:flutter/material.dart';

class GridBackgroundPainter extends CustomPainter {
  GridBackgroundPainter({
    required this.backgroundColor,
    required this.lineColor,
    this.cellSize = 44,
    this.majorEvery = 4,
    this.minorOpacity = 0.08,
    this.majorOpacity = 0.14,
    this.strokeWidth = 1.0,
    this.progress = 1.0,
  });

  final Color backgroundColor;
  final Color lineColor;

  final double cellSize;
  final int majorEvery;

  final double minorOpacity;
  final double majorOpacity;

  final double strokeWidth;

  // Build-in progress: 0 = nothing drawn, 1 = full grid.
  final double progress;

  // Per-line stagger
  double _hash(int seed) {
    final x = math.sin(seed * 12.9898) * 43758.5453;
    return x - x.floorToDouble();
  }

  double _lineProgress(int lineSeed) {
    final start = _hash(lineSeed) * 0.55;
    final duration = 0.35 + _hash(lineSeed * 31 + 7) * 0.4;
    return ((progress - start) / duration).clamp(0.0, 1.0);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Offset.zero & size, bgPaint);

    final minorPaint = Paint()
      ..color = lineColor.withValues(alpha: minorOpacity)
      ..strokeWidth = strokeWidth;

    final majorPaint = Paint()
      ..color = lineColor.withValues(alpha: majorOpacity)
      ..strokeWidth = strokeWidth;

    final actualCellSize = cellSize > 0 ? cellSize : 44.0;

    // Vertical lines
    double x = 0;
    int col = 0;
    while (x <= size.width) {
      final p = (majorEvery > 0 && col % majorEvery == 0)
          ? majorPaint
          : minorPaint;
      final lp = _lineProgress(col * 2);
      if (lp > 0) {
        canvas.drawLine(Offset(x, 0), Offset(x, size.height * lp), p);
      }
      x += actualCellSize;
      col++;
    }

    // Horizontal lines
    double y = 0;
    int row = 0;
    while (y <= size.height) {
      final p = (majorEvery > 0 && row % majorEvery == 0)
          ? majorPaint
          : minorPaint;
      final lp = _lineProgress(row * 2 + 1);
      if (lp > 0) {
        canvas.drawLine(Offset(0, y), Offset(size.width * lp, y), p);
      }
      y += actualCellSize;
      row++;
    }

    // Vignette
    final vignette = Paint()
      ..shader =
          RadialGradient(
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.10 * progress),
            ],
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
    return oldDelegate.progress != progress ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.cellSize != cellSize ||
        oldDelegate.majorEvery != majorEvery ||
        oldDelegate.minorOpacity != minorOpacity ||
        oldDelegate.majorOpacity != majorOpacity ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
