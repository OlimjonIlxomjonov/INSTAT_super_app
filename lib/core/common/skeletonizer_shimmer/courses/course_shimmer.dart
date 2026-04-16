import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonMinimalCourseCard extends StatelessWidget {
  const SkeletonMinimalCourseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: appH(20), top: 10),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyScale.grey200),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        spacing: appW(10),
        children: [
          // Thumbnail placeholder
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Skeletonizer(
                enabled: true,
                child: Container(
                  height: appH(100),
                  decoration: BoxDecoration(
                    color: AppColors.greyScale.grey200,
                    borderRadius: .circular(12),
                  ),
                ),
              ),
            ),
          ),
          // Text placeholders
          Expanded(
            flex: 2,
            child: Skeletonizer(
              enabled: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 8),
                  Container(height: 12, width: 100, color: Colors.grey),
                  SizedBox(height: 10),
                  Container(height: 12, width: 140, color: Colors.grey),
                  SizedBox(height: 10),
                  Container(
                    height: 8,
                    width: double.infinity,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// skeleton for expanded layout
class SkeletonExpandedCourseCard extends StatelessWidget {
  const SkeletonExpandedCourseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Padding(
        padding: EdgeInsets.only(bottom: appH(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: appH(160),
                width: double.infinity,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: appH(12)),
            Container(height: 12, width: 80, color: Colors.grey),
            SizedBox(height: appH(4)),
            Container(height: 15, width: double.infinity, color: Colors.grey),
            SizedBox(height: appH(8)),
            Container(height: 13, width: 160, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
