import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/general_widgets/bottom_nav_bar_custom_mini_app/bottom_nav_bar_custom_mini_app.dart';
import 'package:my_template/features/mikro_data/presentation/screens/home/mikro_data_home_page.dart';
import 'package:my_template/features/mikro_data/presentation/screens/profile/micro_data_profile.dart';
import 'package:my_template/features/mikro_data/presentation/screens/reports/reports_page.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/micro_data_requets.dart';

import '../../../core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';

class MikroDataBottomNavBar extends StatelessWidget {
  final int? openPageByIndex;

  const MikroDataBottomNavBar({super.key, this.openPageByIndex});

  void _openSeeAllRequests(BuildContext context) {
    openMiniAppSheetFamily(
      enableDrag: true,
      showHandler: false,
      context,
      child: const MicroDataRequets(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return BottomNavBarCustomMiniApp(
      openPageByIndex: openPageByIndex,
      onTabChangeOverride: (context, newIndex) {
        if (newIndex == 2) {
          openMiniAppSheetFamily(
            enableDrag: true,
            showHandler: false,
            context,
            child: const MicroDataRequets(),
          );
          return true; // Ignore tab change
        }
        return false;
      },
      innerPageBuilder: (goToTab) => [
        MicroDataHomePage(
          onProfileTap: () => goToTab(3),
          onSeeAllRequests: () => _openSeeAllRequests(context),
        ),
        const ReportsPage(),
        const SizedBox(),
        const MicroDataProfile(),
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
