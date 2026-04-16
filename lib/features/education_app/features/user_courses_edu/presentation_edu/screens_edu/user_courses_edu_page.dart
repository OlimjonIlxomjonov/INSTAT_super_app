import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:my_template/core/common/ui_states/empty_state.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/custom_tab_bar/custom_tab_bar_wg.dart';
import 'package:my_template/core/utils/widgets/edu_categories/edu_categories_wg.dart';
import 'package:my_template/core/utils/widgets/extend_section/title_with_layout_selector_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses/user_courses_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/components/courses_in_progress_compnent.dart';

class UserCoursesEduPage extends StatefulWidget {
  const UserCoursesEduPage({super.key});

  @override
  State<UserCoursesEduPage> createState() => _UserCoursesEduPageState();
}

class _UserCoursesEduPageState extends State<UserCoursesEduPage>
    with SingleTickerProviderStateMixin {
  CoursesLayout layout = CoursesLayout.grid;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
            child: Row(children: List.generate(5, (_) => EduCategoriesWg())),
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
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                /// Tab 1 — In Progress
                _UserCoursesTabContent(state: 'in_progress', layout: layout),

                /// Tab 2 — Finished
                _UserCoursesTabContent(state: 'finished', layout: layout),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UserCoursesTabContent extends StatefulWidget {
  final String state;
  final CoursesLayout layout;

  const _UserCoursesTabContent({required this.state, required this.layout});

  @override
  State<_UserCoursesTabContent> createState() => _UserCoursesTabContentState();
}

class _UserCoursesTabContentState extends State<_UserCoursesTabContent>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (_) => GetIt.instance<UserCoursesBloc>(),
      child: CustomScrollView(
        slivers: [
          CoursesInProgressComponent(
            layout: widget.layout,
            state: widget.state,
          ),
        ],
      ),
    );
  }
}
