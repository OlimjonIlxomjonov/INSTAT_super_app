import 'package:flutter/material.dart';

class BoughtBookOpenerWg extends StatefulWidget {
  const BoughtBookOpenerWg({super.key});

  @override
  State<BoughtBookOpenerWg> createState() => _BoughtBookOpenerWgState();
}

class _BoughtBookOpenerWgState extends State<BoughtBookOpenerWg>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _dragAmount = 0.0;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
  }

  void _onPanUpdate(DragUpdateDetails details, double width) {
    setState(() {
      _dragAmount += details.delta.dx / width;
      _dragAmount = _dragAmount.clamp(-1.0, 0.0);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_dragAmount.abs() > 0.3) {
      _controller.animateTo(1.0, curve: Curves.easeOut).then((_) {
        setState(() {
          _currentIndex++;
          _dragAmount = 0;
          _controller.reset();
        });
      });
    } else {
      _controller.animateTo(0.0, curve: Curves.easeIn).then((_) {
        setState(() => _dragAmount = 0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Combine drag and animation values
    double ratio = _controller.isAnimating
        ? _controller.value
        : _dragAmount.abs();

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: GestureDetector(
        onHorizontalDragUpdate: (d) => _onPanUpdate(d, size.width),
        onHorizontalDragEnd: _onPanEnd,
        child: Stack(
          children: [
            // 1. The Underneath Page (Next Page)
            _buildPage(_currentIndex + 1),

            // 2. The Current Page with Curl Clipping
            ClipPath(
              clipper: PageCurlClipper(ratio),
              child: _buildPage(_currentIndex),
            ),

            // 3. The "Fold" Shadow/Back of Page
            CustomPaint(painter: CurlShadowPainter(ratio), size: size),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    return Container(
      key: ValueKey(index),
      color: Colors.white,
      child: Center(
        child: Text("Page $index", style: const TextStyle(fontSize: 30)),
      ),
    );
  }
}

// This cuts the current page to reveal the one underneath
class PageCurlClipper extends CustomClipper<Path> {
  final double ratio;

  PageCurlClipper(this.ratio);

  @override
  Path getClip(Size size) {
    Path path = Path();
    // Move the "fold" line across the screen based on drag
    double foldX = size.width * (1 - ratio);
    path.lineTo(foldX, 0);
    path.lineTo(foldX, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant PageCurlClipper oldClipper) =>
      oldClipper.ratio != ratio;
}

// This draws the subtle shadow and highlight at the fold
class CurlShadowPainter extends CustomPainter {
  final double ratio;

  CurlShadowPainter(this.ratio);

  @override
  void paint(Canvas canvas, Size size) {
    if (ratio <= 0) return;

    double foldX = size.width * (1 - ratio);
    double shadowWidth = 30.0;

    Paint paint = Paint()
      ..shader =
          LinearGradient(
            colors: [Colors.black.withOpacity(0.2), Colors.transparent],
          ).createShader(
            Rect.fromLTWH(foldX - shadowWidth, 0, shadowWidth, size.height),
          );

    canvas.drawRect(
      Rect.fromLTWH(foldX - shadowWidth, 0, shadowWidth, size.height),
      paint,
    );

    // Draw the "Back" edge of the paper
    Paint edgePaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(foldX, 0, 2, size.height), edgePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
