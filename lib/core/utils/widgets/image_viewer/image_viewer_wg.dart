import 'package:flutter/material.dart';

class ImageViewerPage extends StatelessWidget {
  final ImageProvider image;
  final String heroTag;

  const ImageViewerPage({
    super.key,
    required this.image,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: Center(
          child: Hero(
            tag: heroTag,
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 5,
              child: Image(image: image, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }
}
