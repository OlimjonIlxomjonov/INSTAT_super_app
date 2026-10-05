import 'package:my_template/core/utils/general_widgets/appear/appear_wg.dart';
import 'package:flutter/material.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';
import 'package:my_template/core/common/refresh_indicator/custom_refresh_insidcator.dart';
import 'package:my_template/core/common/ui_states/section_error_wg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/offline_course/offline_course_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/offline_course/offline_course_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets_edu/offline_courser/offline_course_wg.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/components/user_groupes/detailed_user_group_component.dart';

class OfflineCoursesComponent extends StatelessWidget {
  const OfflineCoursesComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      onRefresh: () async =>
          context.read<OfflineCourseBloc>().add(OfflineCourseEvent()),
      child: BlocBuilder<OfflineCourseBloc, OfflineCourseState>(
        builder: (context, state) {
          if (state is OfflineCourseLoaded) {
            final data = state.response.data;

            if (data.isEmpty) {
              final localization = AppLocalizations.of(context)!;
              return _Scrollable(
                child: AppEmptyState(
                  title: localization.offlineCoursesNotFound,
                  subtitle: localization.offlineCoursesEmptySubtitle,
                ),
              );
            }

            return AppearScope(
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final item = data[index];
                  return AppearItem(
                    key: ValueKey(item.id),
                    id: item.id,
                    child: GestureDetector(
                      behavior: .opaque,
                      onTap: () {
                        openMiniAppSheetFamily(
                          context,
                          showHandler: false,
                          child: DetailedUserGroupComponent(
                            courseName: item.name,
                            courseGroupId: item.id,
                            teacherName: item.teachers,
                          ),
                        );
                      },
                      child: OfflineCourseWg(item: item),
                    ),
                  );
                },
              ),
            );
          }
          if (state is OfflineCourseError) {
            return _Scrollable(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: SectionErrorWg(
                  title: state.message,
                  onRetry: () => context.read<OfflineCourseBloc>().add(
                    OfflineCourseEvent(),
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

//! Bo'sh holatda ham tortib yangilansin
class _Scrollable extends StatelessWidget {
  final Widget child;

  const _Scrollable({required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: child,
        ),
      ),
    );
  }
}
