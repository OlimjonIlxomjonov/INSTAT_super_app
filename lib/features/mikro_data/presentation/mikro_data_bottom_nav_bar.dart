import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
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
      child: const MicroDataRequests(),
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
            child: const MicroDataRequests(),
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
          icon: FlutterRemix.home_line,
          activeIcon: FlutterRemix.home_fill,
          label: localization.homePage,
        ),
        MiniAppBottomNavTabItem(
          icon: FlutterRemix.folder_3_line,
          activeIcon: FlutterRemix.folder_3_fill,
          label: localization.reports,
        ),
        MiniAppBottomNavTabItem(
          icon: FlutterRemix.clipboard_line,
          activeIcon: FlutterRemix.clipboard_fill,
          label: localization.myRequestsTab,
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
