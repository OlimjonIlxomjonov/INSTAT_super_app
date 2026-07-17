import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/general_widgets/bottom_nav_bar_custom_mini_app/bottom_nav_bar_custom_mini_app.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/home_edu_page.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/screens_edu/stats_edu_page.dart';
import 'package:my_template/features/education_app/features/table_edu/presentation_edu/screens_edu/table_edu_page.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/user_courses_edu_page.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/user_profile_edu.dart';

class EduBottomNavBar extends StatelessWidget {
  final int? openPageByIndex;

  const EduBottomNavBar({super.key, this.openPageByIndex});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return BottomNavBarCustomMiniApp(
      openPageByIndex: openPageByIndex,
      innerPageBuilder: (goToTab) => [
        HomeEduPage(onTap: () => goToTab(2), onProfileTap: () => goToTab(4)),
        const TableEduPage(),
        const UserCoursesEduPage(),
        const StatsEduPage(),
        const UserProfileEdu(),
      ],
      tabs: [
        MiniAppBottomNavTabItem(
          icon: FlutterRemix.home_line,
          activeIcon: FlutterRemix.home_fill,
          label: localization.homePage,
        ),
        MiniAppBottomNavTabItem(
          icon: FlutterRemix.table_line,
          activeIcon: FlutterRemix.table_fill,
          label: localization.schedule,
        ),
        MiniAppBottomNavTabItem(
          icon: FlutterRemix.book_line,
          activeIcon: FlutterRemix.book_fill,
          label: localization.myCourses,
        ),
        MiniAppBottomNavTabItem(
          icon: FlutterRemix.pie_chart_line,
          activeIcon: FlutterRemix.pie_chart_fill,
          label: localization.statistics,
        ),
        MiniAppBottomNavTabItem(
          icon: FlutterRemix.user_line,
          activeIcon: FlutterRemix.user_fill,
          label: localization.profile,
        ),
      ],
    );
  }
}
