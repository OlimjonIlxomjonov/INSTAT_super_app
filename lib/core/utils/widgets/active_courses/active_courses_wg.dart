import 'package:dashed_progress_bar/dashed_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/general_widgets/custom_linear_indicator/custom_linear_indicator_wg.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/responsiveness/responsive.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';

class ActiveCoursesWg extends StatelessWidget {
  final VoidCallback onTap;
  final bool showCircularProgBar;
  final CourseEntity data;
  final String categoryName;

  const ActiveCoursesWg({
    super.key,
    required this.onTap,
    this.showCircularProgBar = true,
    required this.data,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 80),
        margin: .only(bottom: 12, right: isTablet ? 20 : 0),
        padding: .symmetric(horizontal: 8, vertical: isTablet ? 8 : 5),
        decoration: BoxDecoration(
          borderRadius: .circular(12),
          border: Border.all(color: AppColors.greyScale.grey200),
        ),
        child: Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                  aspectRatio: 16 / 9, //? 16 / 9 default
                  child: Image.network(
                    data.thumbnail,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) =>
                        progress == null
                        ? child
                        : const Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                    errorBuilder: (_, obj, t) => const Icon(Icons.broken_image),
                  ),
                ),
              ),
            ),
            SizedBox(width: appW(12)),
            Expanded(
              flex: Responsive.isMobile(context) ? 1 : 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// category name
                  Text(
                    categoryName,
                    style: AppTextStyles.source.medium(
                      fontSize: 12,
                      color: AppColors.primaryColor,
                    ),
                  ),

                  /// course name
                  Text(
                    data.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.source.medium(fontSize: 14),
                  ),

                  /// desc
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text('7/24 Mavzu', style: CustomTextStyles.h4),
                      if (!showCircularProgBar)
                        Text(
                          '0%',
                          style: AppTextStyles.source.regular(
                            fontSize: 12,
                            color: AppColors.greyScale.grey600,
                          ),
                        ),
                    ],
                  ),
                  if (!showCircularProgBar)
                    CustomLinearIndicatorWg(progressIndicator: 0.0),
                ],
              ),
            ),
            SizedBox(width: 12),
            if (showCircularProgBar)
              SizedBox(
                width: 66,
                height: 66,
                child: Padding(
                  padding: EdgeInsets.all(Responsive.isMobile(context) ? 4 : 0),
                  child: DashedCircularProgressBar(
                    progress: data.userOrder!.progress / 10,
                    maxProgress: 10,
                    corners: StrokeCap.butt,
                    foregroundColor: AppColors.primaryColor,
                    backgroundColor: Color(0xffeeeeee),
                    foregroundStrokeWidth: 4,
                    backgroundStrokeWidth: 4,
                    animation: true,
                    width: 5,
                    height: 5,
                    child: Center(
                      child: Text(
                        "${(data.userOrder?.progress ?? 0).toInt()} %",
                        style: AppTextStyles.source.medium(fontSize: 12),
                      ),
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
