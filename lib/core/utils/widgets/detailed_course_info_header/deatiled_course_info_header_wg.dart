import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/html_content_wg/html_content_wg.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/per_course/per_course_bloc.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/per_course/per_course_state.dart';
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
    final localization = AppLocalizations.of(context)!;
    final localeCode = Localizations.localeOf(context).languageCode;

    return SliverMainAxisGroup(
      slivers: [
        /// Metadata row
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    Icon(IconlyBold.star, color: AppColors.orange, size: 17),
                    Text(
                      " ${data.userOrder?.status != 'paid' ? data.ratingsCount ?? 0 : data.userOrder?.scores ?? 0.0}",
                      style: AppTextStyles.source.medium(
                        fontSize: 13,
                        color: AppColors.greyScale.grey600,
                      ),
                    ),
                    SizedBox(width: appH(12)),
                    Icon(
                      IconlyLight.document,
                      color: AppColors.greyScale.grey600,
                      size: 17,
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
                      size: 17,
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
              ],
            ),
          ),
        ),

        /// Description card
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, appH(16), 20, 0),
            child: RepaintBoundary(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.greyScale.grey200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localization.courseDescriptionTitle,
                        style: AppTextStyles.source.medium(fontSize: 16),
                      ),
                      SizedBox(height: appH(8)),
                      HtmlContentWg(
                        collapsedLines: 10,
                        htmlData:
                            data.localizedDescription(localeCode) ??
                            localization.descriptionNotProvidedForLanguage,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
