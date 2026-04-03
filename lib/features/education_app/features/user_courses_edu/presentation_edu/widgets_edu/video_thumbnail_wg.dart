import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class VideoThumbnailWidget extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onTap;

  const VideoThumbnailWidget({
    super.key,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imagePath != null && imagePath!.isNotEmpty)
            Image.network(
              imagePath!,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Skeletonizer(
                  enabled: true,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.grey.shade300,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey.shade300,
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          else
            Skeletonizer(
              enabled: true,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.grey.shade300,
              ),
            ),
          Container(color: Colors.black.withValues(alpha: 0.3)),
          Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
