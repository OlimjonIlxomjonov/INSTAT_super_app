import 'package:flutter/material.dart';

import '../../../../../../core/utils/app_utils.dart';

class AvatarViewerPage extends StatelessWidget {
  final ImageProvider image;
  final String heroTag;

  const AvatarViewerPage({
    super.key,
    required this.image,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Dismiss on background tap
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const SizedBox.expand(),
          ),

          // Image with pinch-to-zoom
          Center(
            child: Hero(
              tag: heroTag,
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 4.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image(
                    image: image,
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: MediaQuery.of(context).size.width * 0.85,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.width * 0.85,
                      color: AppColors.greyScale.grey200,
                      child: Icon(
                        Icons.person,
                        size: 80,
                        color: AppColors.greyScale.grey600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Close button
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
