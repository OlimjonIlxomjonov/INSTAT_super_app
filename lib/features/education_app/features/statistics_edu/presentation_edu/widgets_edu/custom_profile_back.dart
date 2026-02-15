import 'dart:math' as math;
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.background,
    required this.avatar,
    this.maxWidth = 420,
    this.bannerHeight = 160,
    this.avatarRadius = 48,
    this.cornerRadius = 18,
    this.ring = 4,
  });

  final ImageProvider background;
  final ImageProvider avatar;

  final double maxWidth;
  final double bannerHeight;
  final double avatarRadius;
  final double cornerRadius;
  final double ring;

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final w = math.min(screenW, maxWidth);
    final overlap = avatarRadius;

    return Center(
      child: SizedBox(
        width: w,
        height: bannerHeight + overlap,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            // Banner
            ClipRRect(
              borderRadius: BorderRadius.circular(cornerRadius),
              child: Image(
                image: background,
                width: w,
                height: bannerHeight,
                fit: BoxFit.cover,
                opacity: AlwaysStoppedAnimation(0.5),
              ),
            ),

            Positioned(
              top: bannerHeight - avatarRadius,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.all(ring),
                  child: CircleAvatar(
                    radius: avatarRadius,
                    backgroundImage: avatar,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
