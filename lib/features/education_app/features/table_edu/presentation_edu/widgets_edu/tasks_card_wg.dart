import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/general_widgets/custom_linear_indicator/custom_linear_indicator_wg.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class TasksCardWg extends StatelessWidget {
  final String title, subTitle, deadlineDate, daysLeft;
  final Color statusBorderColor;
  final VoidCallback onTap;
  final bool? isTaskDone;
  final bool isLessons;

  const TasksCardWg({
    super.key,
    required this.title,
    required this.subTitle,
    required this.deadlineDate,
    required this.onTap,
    required this.daysLeft,
    required this.statusBorderColor,
    required this.isTaskDone,
    this.isLessons = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: .only(bottom: appH(12)),
        padding: .symmetric(horizontal: appW(16), vertical: appH(16)),
        decoration: BoxDecoration(
          color: isTaskDone == null
              ? AppColors.greyScale.grey50
              : isTaskDone!
              ? AppColors.greenBackground
              : AppColors.redBackground,
          border: Border(left: BorderSide(color: statusBorderColor, width: 5)),
          borderRadius: .circular(10),
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            /// TITLE WITH CHECKBOX => NOT INTERACTABLE
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    maxLines: 1,
                    overflow: .ellipsis,
                    title,
                    style: AppTextStyles.source.medium(fontSize: 16),
                  ),
                ),
                SizedBox(width: 23),

                /// CIRCULAR STATUS
                circularStatusCheckBox(),
              ],
            ),

            SizedBox(height: appH(8)),

            /// SUB TITLE
            Row(
              children: [
                if (isLessons)
                  Icon(
                    IconlyLight.profile,
                    size: 20,
                    color: AppColors.greyScale.grey600,
                  ),
                Expanded(
                  child: Text(
                    maxLines: 1,
                    overflow: .ellipsis,
                    subTitle,
                    style: AppTextStyles.source.regular(
                      fontSize: 13,
                      color: AppColors.greyScale.grey600,
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: AppColors.greyScale.grey200),

            /// DEADLINE DATA / TIME
            Row(
              children: [
                Icon(IconlyLight.calendar, color: AppColors.greyScale.grey400),
                Text(
                  deadlineDate,
                  style: AppTextStyles.source.regular(
                    fontSize: 12,
                    color: AppColors.greyScale.grey400,
                  ),
                ),
                Expanded(child: Container()),
                Icon(
                  IconlyLight.time_circle,
                  color: AppColors.greyScale.grey400,
                ),
                Text(
                  daysLeft,
                  style: AppTextStyles.source.regular(
                    fontSize: 12,
                    color: AppColors.greyScale.grey400,
                  ),
                ),
              ],
            ),
            SizedBox(height: appH(8)),

            /// PROGRESS BAR /// TEMP DEFAULT => CHANGE TO PACKAGE
            if (!isLessons)
              Row(
                children: [
                  Expanded(
                    child: CustomLinearIndicatorWg(progressIndicator: 0.4),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '? %',
                    style: AppTextStyles.source.regular(
                      fontSize: 12,
                      color: AppColors.greyScale.grey600,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget circularStatusCheckBox() {
    switch (isTaskDone) {
      case true:
        return Icon(Icons.check_circle, color: AppColors.greenDoneTaskCard);
      case false:
        return Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.redFailedTaskCard,
            shape: BoxShape.circle,
          ),
          alignment: .center,
          child: Icon(Icons.close, color: AppColors.white, size: 20),
        );
      default:
        return Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            border: .all(width: 2, color: AppColors.greyScale.grey600),
            shape: .circle,
          ),
        );
    }
  }
}
