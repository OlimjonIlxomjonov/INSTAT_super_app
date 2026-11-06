import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/ui_states/section_error_wg.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/features/education_app/features/statistics_edu/domain/entity/student_rating/student_rating_entity.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/bloc/student_rating/student_rating_cubit.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserInfoTab extends StatelessWidget {
  const UserInfoTab({super.key});

  static const _skeleton = StudentRatingEntity(
    rank: 10,
    scoreSum: 1000,
    completedCourseCount: 10,
    activeCourseCount: 10,
    completionRate: 100,
    studyHours: 100,
    certificatesCount: 10,
    certificates: [],
  );

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return BlocBuilder<StudentRatingCubit, StudentRatingState>(
      builder: (context, state) {
        final error = state.error;
        if (error != null) {
          return ListView(
            padding: AppPadding.horizontal20x(),
            children: [
              SectionErrorWg(
                title: error.isEmpty ? null : error,
                onRetry: context.read<StudentRatingCubit>().retry,
              ),
            ],
          );
        }

        final data = state.data ?? _skeleton;
        final rank = data.rank;
        return Skeletonizer(
          enabled: state.isLoading,
          child: ListView(
            padding: AppPadding.horizontal20x().copyWith(bottom: appH(20)),
            children: [
              userProfileInfoCardWg(
                localization.userInfoCardTitle,
                [
                  localization.rankLabel,
                  localization.scoreLabel,
                  localization.medalsTab,
                  localization.certificateLabel,
                ],
                [
                  rank == null ? '—' : '#$rank',
                  '${formatPrice(data.scoreSum)} ⭐',
                  '0 🏅',
                  localization.countSuffix(data.certificatesCount),
                ],
              ),
              SizedBox(height: appH(12)),
              userProfileInfoCardWg(
                localization.learningProgressCardTitle,
                [
                  localization.completedCoursesLabel,
                  localization.activeCoursesLabel,
                  localization.completionPercentageLabel,
                  localization.totalEducationTimeLabel,
                ],
                [
                  localization.countSuffix(data.completedCourseCount),
                  localization.countSuffix(data.activeCourseCount),
                  '${data.completionRate.round()}%',
                  localization.durationHours(data.studyHours.round()),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget userProfileInfoCardWg(
    String title,
    List<String> userInfoCard,
    List<String> userTrailing,
  ) {
    return Container(
      width: double.infinity,
      padding: .all(12),
      decoration: BoxDecoration(
        borderRadius: .circular(16),
        border: .all(color: AppColors.greyScale.grey200),
      ),
      child: Column(
        spacing: appH(10),
        crossAxisAlignment: .start,
        children: [
          Text(title, style: AppTextStyles.source.medium(fontSize: 17)),
          ...List.generate(
            userInfoCard.length,
            (index) => Row(
              children: [
                Icon(Icons.star, color: AppColors.primaryColor),
                SizedBox(width: appW(8)),
                Text(
                  userInfoCard[index],
                  style: AppTextStyles.source.medium(
                    fontSize: 14,
                    color: AppColors.greyScale.grey600,
                  ),
                ),
                Expanded(child: Container()),
                Text(
                  userTrailing[index],
                  style: AppTextStyles.source.medium(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
