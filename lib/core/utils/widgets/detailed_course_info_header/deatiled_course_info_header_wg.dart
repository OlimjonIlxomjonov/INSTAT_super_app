import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/general_widgets/html_content_wg/html_content_wg.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';

class DetailedCourseInfoHeaderWg extends StatelessWidget {
  final String categoryName;
  final CourseEntity data;

  const DetailedCourseInfoHeaderWg({
    super.key,
    required this.data,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          /// BODY STARTER CONTENT
          Padding(
            padding: .fromLTRB(appW(20), appH(16), appW(20), 0),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  categoryName,
                  style: AppTextStyles.source.medium(
                    fontSize: 13,
                    color: AppColors.greyScale.grey600,
                  ),
                ),
                SizedBox(height: appH(8)),
                Text(
                  data.name,
                  style: AppTextStyles.source.semiBold(fontSize: 17),
                ),
                SizedBox(height: appH(12)),
                Row(
                  spacing: 5,
                  children: [
                    Icon(Icons.star, color: AppColors.orange),
                    Text(
                      '?',
                      style: AppTextStyles.source.medium(
                        fontSize: 13,
                        color: AppColors.greyScale.grey600,
                      ),
                    ),
                    SizedBox(width: appH(12)),
                    Icon(
                      IconlyLight.document,
                      color: AppColors.greyScale.grey600,
                    ),
                    Text(
                      '${data.lessonsCount} ta',
                      style: AppTextStyles.source.medium(
                        fontSize: 13,
                        color: AppColors.greyScale.grey600,
                      ),
                    ),
                    SizedBox(width: appH(12)),
                    Icon(
                      IconlyLight.time_circle,
                      color: AppColors.greyScale.grey600,
                    ),
                    Text(
                      formatDuration(data.totalDuration),
                      style: AppTextStyles.source.medium(
                        fontSize: 13,
                        color: AppColors.greyScale.grey600,
                      ),
                    ),
                  ],
                ),

                /// DESCRIPTION CARD
                Container(
                  margin: .only(top: appH(16)),
                  padding: .all(12),
                  decoration: BoxDecoration(
                    borderRadius: .circular(12),
                    border: .all(color: AppColors.greyScale.grey200),
                  ),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        'Izoh',
                        style: AppTextStyles.source.medium(fontSize: 16),
                      ),
                      SizedBox(height: appH(8)),
                      HtmlContentWg(
                        collapsedLines: 10,
                        htmlData: data.descriptionUz ?? 'No Description',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
