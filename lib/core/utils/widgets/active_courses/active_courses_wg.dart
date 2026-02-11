import 'package:dashed_progress_bar/dashed_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class ActiveCoursesWg extends StatelessWidget {
  const ActiveCoursesWg({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
    return Container(
      margin: .only(bottom: appH(12)),
      padding: .all(8),
      decoration: BoxDecoration(
        borderRadius: .circular(12),
        border: Border.all(color: AppColors.greyScale.grey200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: .circular(8),
            child: Image.asset(
              'assets/home_page/temp_course_dummy.png',
              fit: BoxFit.cover,
              width: appW(64),
              height: appH(60),
            ),
          ),
          SizedBox(width: appW(12)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Kotegoriyani nomi',
                  style: AppTextStyles.source.medium(
                    fontSize: 12,
                    color: AppColors.primaryColor,
                  ),
                ),
                Text(
                  'Statistika (Tarmoqlar va sohalar bo’yicha)',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.source.medium(fontSize: 16),
                ),
                Text(
                  '7/24 Mavzu',
                  style: AppTextStyles.source.regular(fontSize: 13),
                ),
              ],
            ),
          ),
          SizedBox(width: appW(12)),
          SizedBox(
            width: appW(56),
            height: appH(56),
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
                child: Text(
                  '50%',
                  style: AppTextStyles.source.medium(fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
