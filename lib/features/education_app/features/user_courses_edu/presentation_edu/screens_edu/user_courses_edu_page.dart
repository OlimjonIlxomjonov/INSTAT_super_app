import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/widgets/custom_tab_bar/custom_tab_bar_wg.dart';
import 'package:my_template/core/utils/widgets/extend_section/title_with_layout_selector_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/offline_course/offline_course_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/components/offline_courses_component.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/components/user_course_tab_content.dart';

class UserCoursesEduPage extends StatefulWidget {
  const UserCoursesEduPage({super.key});

  @override
  State<UserCoursesEduPage> createState() => _UserCoursesEduPageState();
}

class _UserCoursesEduPageState extends State<UserCoursesEduPage>
    with SingleTickerProviderStateMixin {
  CoursesLayout layout = CoursesLayout.grid;
  late TabController _tabController;
  bool isOffline = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<OfflineCourseBloc>().add(OfflineCourseEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appH(90)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: CustomTabBarWg(
            controller: _tabController,
            firstTab: localization.statusInProgress,
            secondTab: localization.finished,
            thirdTab: localization.offlineCoursesTab,
          ),
        ),
      ),
      body: Column(
        children: [
          //! Categories row

          // Padding(
          //   padding: const EdgeInsets.only(left: 20),
          //   child: Row(
          //     children: [
          //       GestureDetector(
          //         onTap: () {
          //           setState(() {
          //             isOffline = !isOffline;
          //           });
          //         },
          //         child: Container(
          //           padding: const .symmetric(vertical: 6, horizontal: 10),
          //           decoration: BoxDecoration(
          //             border: .all(
          //               color: isOffline
          //                   ? AppColors.primaryColor
          //                   : AppColors.greyScale.grey200,
          //             ),
          //             borderRadius: .circular(10),
          //           ),
          //           child: Row(
          //             children: [
          //               Icon(
          //                 CupertinoIcons.square_grid_2x2,
          //                 color: isOffline
          //                     ? AppColors.primaryColor
          //                     : AppColors.greyScale.grey600,
          //               ),
          //               Text(
          //                 ' Oflayn kurslar',
          //                 style: AppTextStyles.source.medium(
          //                   fontSize: 13,
          //                   color: isOffline
          //                       ? AppColors.primaryColor
          //                       : AppColors.greyScale.grey600,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          //! Layout selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TitleWithLayoutSelectorWg(
              text: localization.myCoursesTitle,
              prefsKey: "user_courses",
              onChanged: (newLayout) => setState(() => layout = newLayout),
            ),
          ),

          //! Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                /// Tab 1 — In Progress
                UserCoursesTabContent(state: 'in_progress', layout: layout),

                /// Tab 2 — Finished
                UserCoursesTabContent(state: 'finished', layout: layout),

                /// Tab 3 - Offline Courses
                OfflineCoursesComponent(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
