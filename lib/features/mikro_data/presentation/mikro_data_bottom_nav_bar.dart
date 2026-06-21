import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/general_widgets/bottom_nav_bar_custom_mini_app/bottom_nav_bar_custom_mini_app.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/home_edu_page.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/screens_edu/stats_edu_page.dart';
import 'package:my_template/features/education_app/features/table_edu/presentation_edu/screens_edu/table_edu_page.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/user_courses_edu_page.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/user_profile_edu.dart';
import 'package:my_template/features/mikro_data/presentation/screens/home/mikro_data_home_page.dart';
import 'package:my_template/features/mikro_data/presentation/screens/reports/reports_page.dart';

class MikroDataBottomNavBar extends StatelessWidget {
  final int? openPageByIndex;

  const MikroDataBottomNavBar({super.key, this.openPageByIndex});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return BottomNavBarCustomMiniApp(
      openPageByIndex: openPageByIndex,
      innerPageBuilder: (goToTab) => [
        MicroDataHomePage(onProfileTap: () => goToTab(3)),
        const ReportsPage(),
        const ReportsPage(),
        const ReportsPage(),
      ],
      tabs: [
        MiniAppBottomNavTabItem(
          icon: IconlyLight.home,
          activeIcon: IconlyBold.home,
          label: localization.homePage,
        ),
        MiniAppBottomNavTabItem(
          icon: IconlyLight.folder,
          activeIcon: IconlyBold.folder,
          label: 'Hisobotlar',
        ),
        MiniAppBottomNavTabItem(
          icon: IconlyLight.document,
          activeIcon: IconlyBold.document,
          label: "So’rovlarim",
        ),
        MiniAppBottomNavTabItem(
          icon: IconlyLight.profile,
          activeIcon: IconlyBold.profile,
          label: localization.profile,
        ),
      ],
    );
  }
}
