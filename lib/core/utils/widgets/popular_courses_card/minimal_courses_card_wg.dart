import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/general_widgets/custom_linear_indicator/custom_linear_indicator_wg.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';

class MinimalCoursesCardWg extends StatelessWidget {
  final VoidCallback onTap;
  final CourseEntity data;
  final String categoryName;

  const MinimalCoursesCardWg({
    super.key,
    required this.onTap,
    required this.data,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: appH(20)),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyScale.grey200),
          borderRadius: BorderRadius.circular(16),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(data.thumbnail, fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(width: appW(10)),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            data.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.source.medium(fontSize: 15),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.greyScale.grey200,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(IconlyLight.heart),
                        ),
                      ],
                    ),
                    Text(
                      categoryName,
                      style: AppTextStyles.source.medium(
                        fontSize: 12,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    if (data.userOrder?.status == 'paid')
                      Row(
                        children: [
                          Expanded(
                            child: CustomLinearIndicatorWg(
                              progressIndicator: data.userOrder?.progress ?? 0,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "${(data.userOrder?.progress ?? 0).toInt()} %",
                            style: CustomTextStyles.h4,
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: AppColors.yellow500,
                            size: 20,
                          ),
                          Text(' 4,5(832)', style: CustomTextStyles.h4),
                          const SizedBox(width: 10),
                          Icon(
                            IconlyLight.document,
                            size: 20,
                            color: AppColors.greyScale.grey400,
                          ),
                          Text(
                            ' ${data.lessonsCount} ta',
                            style: CustomTextStyles.h4,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
