import 'package:auto_size_text/auto_size_text.dart';
import 'package:dashed_progress_bar/dashed_progress_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/general_widgets/custom_linear_indicator/custom_linear_indicator_wg.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/responsiveness/responsive.dart';

class ActiveCoursesWg extends StatelessWidget {
  final VoidCallback onTap;
  final bool showCircularProgBar;

  const ActiveCoursesWg({
    super.key,
    required this.onTap,
    this.showCircularProgBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: .only(bottom: 12),
        padding: .symmetric(
          horizontal: 8,
          vertical: Responsive.isTablet(context) ? 8 : 5,
        ),
        decoration: BoxDecoration(
          borderRadius: .circular(12),
          border: Border.all(color: AppColors.greyScale.grey200),
        ),
        child: Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: .circular(8),
                child: Image.asset(
                  'assets/home_page/temp_course_dummy.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: appW(12)),

            Expanded(
              flex: Responsive.isMobile(context) ? 2 : 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AutoSizeText(
                    'Kotegoriyani nomi',
                    style: AppTextStyles.source.medium(
                      fontSize: 12,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  AutoSizeText(
                    'Statistika (Tarmoqlar va sohalar bo’yicha)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.source.medium(fontSize: 16),
                  ),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      AutoSizeText(
                        '7/24 Mavzu',
                        style: AppTextStyles.source.regular(fontSize: 13),
                      ),
                      if (!showCircularProgBar)
                        AutoSizeText(
                          '25%',
                          style: AppTextStyles.source.regular(
                            fontSize: 12,
                            color: AppColors.greyScale.grey600,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 9),
                  if (!showCircularProgBar)
                    CustomLinearIndicatorWg(progressIndicator: 0.25),
                ],
              ),
            ),
            SizedBox(width: appW(12)),
            if (showCircularProgBar)
              SizedBox(
                width: 56,
                height: 56,
                child: Padding(
                  padding: EdgeInsets.all(Responsive.isMobile(context) ? 4 : 0),
                  child: DashedCircularProgressBar(
                    progress: 5,
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
                      child: AutoSizeText(
                        '50%',
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
