import 'package:flutter/material.dart';

class PageCurlClipper extends CustomClipper<Path> {
  final double drag;

  PageCurlClipper(this.drag);

  @override
  Path getClip(Size size) {
    final path = Path();

    double curl = drag.clamp(0, size.width);

    path.moveTo(0, 0);
    path.lineTo(size.width - curl, 0);

    path.quadraticBezierTo(
      size.width - curl / 2,
      size.height / 2,
      size.width - curl,
      size.height,
    );

    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(PageCurlClipper oldClipper) {
    return oldClipper.drag != drag;
  }
}

/// CUSTOM WITHOUT PACKAGE
// class BoughtBookOpenerWg extends StatelessWidget {
//   const BoughtBookOpenerWg({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final pages = [
//       Container(
//         color: Colors.red,
//         child: const Center(
//           child: Text("Page 1", style: TextStyle(fontSize: 40)),
//         ),
//       ),
//       Container(
//         color: Colors.green,
//         child: const Center(
//           child: Text("Page 2", style: TextStyle(fontSize: 40)),
//         ),
//       ),
//       Container(
//         color: Colors.blue,
//         child: const Center(
//           child: Text("Page 3", style: TextStyle(fontSize: 40)),
//         ),
//       ),
//     ];
//
//     return Scaffold(body: PageCurlView(pages: pages));
//   }
// }
