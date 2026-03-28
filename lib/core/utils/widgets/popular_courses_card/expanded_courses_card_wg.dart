import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';

class ExpandedCoursesCardWg extends StatelessWidget {
  final VoidCallback onTap;
  final CourseEntity entity;
  final String categoryName;

  const ExpandedCoursesCardWg({
    super.key,
    required this.onTap,
    required this.entity,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: appH(16)),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(entity.thumbnail, fit: BoxFit.cover),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      margin: EdgeInsets.only(left: appW(12), top: appH(12)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.white,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.star, color: AppColors.yellow),
                          Text('?'),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      margin: EdgeInsets.only(right: appW(12), top: appH(12)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.white,
                      ),
                      child: Icon(IconlyLight.heart),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: appH(12)),
            Text(
              categoryName,
              style: AppTextStyles.source.medium(
                fontSize: 12,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: appH(4)),
            Text(
              entity.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.source.medium(fontSize: 15),
            ),
            SizedBox(height: appH(8)),
            Row(
              spacing: 5,
              children: [
                Icon(IconlyLight.time_circle),
                Text(
                  formatDuration(entity.totalDuration),
                  style: AppTextStyles.source.regular(fontSize: 13),
                ),
                SizedBox(width: appW(12)),
                Icon(IconlyLight.document),
                Text(
                  '${entity.lessonsCount} ta dars',
                  style: AppTextStyles.source.regular(fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
