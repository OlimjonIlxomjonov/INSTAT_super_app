import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/general_widgets/bottom_nav_bar_custom_mini_app/bottom_nav_bar_custom_mini_app.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/home_lib_page.dart';
import 'package:my_template/features/online_library_app/features/offline_books_lib/presentation_lib/screens_lib/offline_books_lib_page.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/presentation_lib/screens_lib/user_online_book_cart_lib_page.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_profile_lib/presentation_lib/screens_lib/user_online_book_profile_lib.dart';
import 'package:my_template/features/online_library_app/features/user_online_books_lib/presentation_lib/screens_lib/user_online_books_lib_page.dart';

class OnlineLibBottomNavBar extends StatelessWidget {
  final int? openPageByIndex;

  const OnlineLibBottomNavBar({super.key, this.openPageByIndex});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return BottomNavBarCustomMiniApp(
      openPageByIndex: openPageByIndex,
      onTabChangeOverride: (ctx, newIndex) {
        if (newIndex == 2) {
          openMiniAppSheetFamily(
            ctx,
            isTransparent: false,
            showHandler: false,
            child: const UserOnlineBookCartLibPage(),
          );
          return true;
        }
        return false;
      },
      innerPageBuilder: (goToTab) => [
        HomeLibPage(onTap: () => goToTab(1), onProfileTap: () => goToTab(4)),
        const UserOnlineBooksLibPage(),
        const SizedBox(),
        const OfflineBooksLibPage(),
        const UserOnlineBookProfileLib(),
      ],
      tabs: [
        MiniAppBottomNavTabItem(
          icon: IconlyLight.home,
          activeIcon: IconlyBold.home,
          label: localization.homePage,
        ),
        MiniAppBottomNavTabItem(
          icon: Icons.book_outlined,
          activeIcon: Icons.book,
          label: localization.myBooks,
        ),
        MiniAppBottomNavTabItem(
          icon: IconlyLight.buy,
          activeIcon: IconlyBold.buy,
          label: localization.cart,
        ),
        MiniAppBottomNavTabItem(
          icon: Icons.local_library_outlined,
          activeIcon: Icons.local_library,
          label: localization.library,
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
