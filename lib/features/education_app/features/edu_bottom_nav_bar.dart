import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconly/iconly.dart';
import 'package:line_icons/line_icons.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/home_edu_page.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/screens_edu/stats_edu_page.dart';
import 'package:my_template/features/education_app/features/table_edu/presentation_edu/screens_edu/table_edu_page.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/user_courses_edu_page.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/user_profile_edu.dart';

class EduBottomNavBar extends StatefulWidget {
  final int? openPageByIndex;

  const EduBottomNavBar({super.key, this.openPageByIndex});

  @override
  State<EduBottomNavBar> createState() => _EduBottomNavBarState();
}

class _EduBottomNavBarState extends State<EduBottomNavBar> {
  late int _currentIndex;
  late final List<Widget> _eduPages;

  void _goToTab(int index) => setState(() => _currentIndex = index);

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.openPageByIndex ?? 0;

    _eduPages = [
      HomeEduPage(onTap: () => _goToTab(2), onProfileTap: () => _goToTab(4)),
      const TableEduPage(),
      const UserCoursesEduPage(),
      const StatsEduPage(),
      const UserProfileEdu(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      // body: IndexedStack(index: _currentIndex, children: _eduPages),
      body: _eduPages[_currentIndex],
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(24),
            topLeft: Radius.circular(24),
          ),
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -1),
              color: AppColors.greyScale.grey200,
              blurRadius: 20,
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: GNav(
              selectedIndex: _currentIndex,
              onTabChange: _goToTab,
              tabBorderRadius: 12,
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 200),
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              gap: 8,
              color: AppColors.greyScale.grey600,
              activeColor: AppColors.white,
              iconSize: 24,
              tabBackgroundColor: AppColors.primaryColor,
              padding: EdgeInsets.all(appW(12)),
              tabs: [
                GButton(icon: IconlyLight.home, text: localization.homePage),
                GButton(
                  icon: Icons.table_chart_outlined,
                  text: localization.schedule,
                ),
                GButton(icon: LineIcons.book, text: localization.myCourses),
                GButton(
                  icon: LineIcons.pieChart,
                  text: localization.statistics,
                ),
                GButton(icon: IconlyLight.profile, text: localization.profile),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
