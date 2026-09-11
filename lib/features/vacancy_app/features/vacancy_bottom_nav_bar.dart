import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/general_widgets/bottom_nav_bar_custom_mini_app/bottom_nav_bar_custom_mini_app.dart';
import 'package:my_template/features/vacancy_app/features/presentation/screens/home/vacancy_home_page.dart';
import 'package:my_template/features/vacancy_app/features/presentation/screens/profile/vacancy_profile.dart';
import 'package:my_template/features/vacancy_app/features/presentation/screens/requests/requests_page.dart';
import 'package:my_template/features/vacancy_app/features/presentation/screens/vacancy/vacancies_page.dart';

class VacancyBottomNavBar extends StatelessWidget {
  final int? openPageByIndex;

  const VacancyBottomNavBar({super.key, this.openPageByIndex});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return BottomNavBarCustomMiniApp(
      openPageByIndex: openPageByIndex,
      innerPageBuilder: (goToTab) => [
        VacancyHomePage(
          onProfileTap: () => goToTab(3),
          onSeeAllVacancy: () => goToTab(1),
          onSeeAllRequests: () => goToTab(2),
        ),
        const VacanciesPage(),
        const RequestsPage(),
        const VacancyProfile(),
      ],
      tabs: [
        MiniAppBottomNavTabItem(
          icon: FlutterRemix.home_line,
          activeIcon: FlutterRemix.home_fill,
          label: localization.homePage,
        ),
        MiniAppBottomNavTabItem(
          icon: FlutterRemix.folder_3_line,
          activeIcon: FlutterRemix.folder_3_fill,
          label: localization.vacanciesTitle,
        ),
        MiniAppBottomNavTabItem(
          icon: FlutterRemix.clipboard_line,
          activeIcon: FlutterRemix.clipboard_fill,
          label: localization.applicationsTab,
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
