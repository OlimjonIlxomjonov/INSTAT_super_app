import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/custom_linear_indicator/custom_linear_indicator_wg.dart';
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
                      margin: const EdgeInsets.only(left: 12, top: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.white.withValues(alpha: 0.7),
                      ),
                      child: Row(
                        children: [
                          //! star/ rating
                          Icon(
                            IconlyBold.star,
                            color: AppColors.orange500,
                            size: 18,
                          ),
                          Text(" ${entity.ratingsCount ?? 0}"),
                        ],
                      ),
                    ),
                    //! heart icon

                    // Container(
                    //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    //   margin: EdgeInsets.only(right: appW(12), top: appH(12)),
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(12),
                    //     color: AppColors.white,
                    //   ),
                    //   child: Icon(IconlyLight.heart),
                    // ),
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
            if (entity.userOrder?.status == 'paid')
              Row(
                children: [
                  Expanded(
                    child: CustomLinearIndicatorWg(
                      progressIndicator: entity.userOrder?.progress ?? 0,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${(entity.userOrder?.progress ?? 0).toInt()} %",
                    style: CustomTextStyles.h4,
                  ),
                ],
              )
            else
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
