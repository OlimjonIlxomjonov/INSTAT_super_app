import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/lesson_flow/lesson_watch_tracker.dart';

class LessonWatchStatusWg extends StatelessWidget {
  final ValueListenable<Set<int>> watched;

  const LessonWatchStatusWg({super.key, required this.watched});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return ValueListenableBuilder<Set<int>>(
      valueListenable: watched,
      builder: (context, buckets, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localization.lessonWatchedPercent(
                buckets.length * LessonWatchTracker.percentStep,
              ),
              style: AppTextStyles.source.medium(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                for (var i = 0; i < LessonWatchTracker.bucketCount; i++)
                  Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        color: buckets.contains(i)
                            ? AppColors.primaryColor
                            : AppColors.greyScale.grey200,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              localization.lessonWatchHint,
              style: AppTextStyles.source.regular(
                fontSize: 12,
                color: AppColors.greyScale.grey500,
              ),
            ),
          ],
        );
      },
    );
  }
}
