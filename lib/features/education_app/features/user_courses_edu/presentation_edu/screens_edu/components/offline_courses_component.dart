import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/ui_states/empty_state.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/custom_linear_indicator/custom_linear_indicator_wg.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/offline_course/offline_course_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/offline_course/offline_course_state.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/components/user_groupes/detailed_user_group_component.dart';

class OfflineCoursesComponent extends StatelessWidget {
  const OfflineCoursesComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfflineCourseBloc, OfflineCourseState>(
      builder: (context, state) {
        if (state is OfflineCourseLoaded) {
          final data = state.response.data;

          if (data.isEmpty) {
            return EmptyState();
          }

          return Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return GestureDetector(
                  behavior: .opaque,
                  onTap: () {
                    openMiniAppSheetFamily(
                      context,
                      showHandler: false,
                      child: DetailedUserGroupComponent(courseName: item.name),
                    );
                  },
                  child: Container(
                    margin: .fromLTRB(20, 0, 20, 12),
                    padding: .symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: .all(color: AppColors.greyScale.grey200),
                      borderRadius: .circular(16),
                    ),
                    child: Column(
                      spacing: 8,
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          item.name,
                          style: AppTextStyles.source.medium(fontSize: 16),
                        ),
                        Row(
                          children: [
                            Icon(
                              IconlyLight.calendar,
                              color: AppColors.greyScale.grey600,
                            ),
                            Text(
                              item.course.category?.createdAt
                                      .toReadableDate() ??
                                  '',
                              style: _subStyle(),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: .start,
                          children: [
                            Icon(
                              IconlyLight.profile,
                              color: AppColors.greyScale.grey600,
                            ),
                            Expanded(
                              child: Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: List.generate(item.teachers.length, (
                                  index,
                                ) {
                                  final teacher = item.teachers[index];
                                  return Text(
                                    "${teacher.fullName} |",
                                    style: _subStyle(),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomLinearIndicatorWg(
                                progressIndicator: 25,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text('25%', style: _subStyle()),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  TextStyle _subStyle() {
    return AppTextStyles.source.regular(
      fontSize: 13,
      color: AppColors.greyScale.grey600,
    );
  }
}
