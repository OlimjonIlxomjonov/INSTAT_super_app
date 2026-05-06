import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/widgets/custom_tab_bar/custom_tab_bar_wg.dart';
import 'package:my_template/core/utils/widgets/edu_categories/edu_categories_wg.dart';
import 'package:my_template/core/utils/widgets/extend_section/title_with_layout_selector_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/offline_course/offline_course_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/components/offline_courses_component.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/components/user_course_tab_content.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/components/user_groupes/user_groupers_component.dart';

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
    _tabController = TabController(length: 2, vsync: this);
    context.read<OfflineCourseBloc>().add(OfflineCourseEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appH(90)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: CustomTabBarWg(
            controller: _tabController,
            firstTab: "Jarayonda",
            secondTab: "Tugallangan",
          ),
        ),
      ),
      body: Column(
        children: [
          // Categories row
          SingleChildScrollView(
            padding: EdgeInsets.only(right: 20),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isOffline = !isOffline;
                    });
                  },
                  child: Container(
                    margin: .only(right: 12),
                    padding: const .symmetric(vertical: 6, horizontal: 10),
                    decoration: BoxDecoration(
                      border: .all(
                        color: isOffline
                            ? AppColors.primaryColor
                            : AppColors.greyScale.grey200,
                      ),
                      borderRadius: .circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.grid_3x3,
                          color: isOffline
                              ? AppColors.primaryColor
                              : AppColors.greyScale.grey600,
                        ),
                        Text(
                          ' Oflayn kurslar',
                          style: AppTextStyles.source.medium(
                            fontSize: 13,
                            color: isOffline
                                ? AppColors.primaryColor
                                : AppColors.greyScale.grey600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                  child: VerticalDivider(
                    thickness: 2,
                    color: AppColors.greyScale.grey200,
                  ),
                ),
                ...List.generate(5, (_) => EduCategoriesWg()),
              ],
            ),
          ),

          // Layout selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TitleWithLayoutSelectorWg(
              prefsKey: "user_courses",
              onChanged: (newLayout) => setState(() => layout = newLayout),
            ),
          ),

          // Tab content
          !isOffline
              ? Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      /// Tab 1 — In Progress
                      UserCoursesTabContent(
                        state: 'in_progress',
                        layout: layout,
                      ),

                      /// Tab 2 — Finished
                      UserCoursesTabContent(state: 'finished', layout: layout),
                    ],
                  ),
                )
              : OfflineCoursesComponent(),
        ],
      ),
    );
  }
}
