import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/common/ui_states/empty_state.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/offline_course/offline_course_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/offline_course/offline_course_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets_edu/offline_courser/offline_course_wg.dart';
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
            return AppEmptyState(
              title: 'Oflayn kurslar topilmadi.',
              subtitle:
                  'Ayni paytda faol oflayn mashg‘ulotlar yo‘q. Tez orada yangi yo‘nalishlarni yo‘lga qo‘yamiz.',
            );
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return GestureDetector(
                behavior: .opaque,
                onTap: () {
                  openMiniAppSheetFamily(
                    context,
                    showHandler: false,
                    child: DetailedUserGroupComponent(
                      courseName: item.name,
                      courseGroupId: item.id,
                    ),
                  );
                },
                child: OfflineCourseWg(item: item),
              );
            },
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
