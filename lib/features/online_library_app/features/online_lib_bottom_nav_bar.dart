import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconly/iconly.dart';
import 'package:line_icons/line_icons.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/home_lib_page.dart';
import 'package:my_template/features/online_library_app/features/offline_books_lib/presentation_lib/screens_lib/offline_books_lib_page.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/presentation_lib/screens_lib/user_online_book_cart_lib_page.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_profile_lib/presentation_lib/screens_lib/user_online_book_profile_lib.dart';
import 'package:my_template/features/online_library_app/features/user_online_books_lib/presentation_lib/screens_lib/user_online_books_lib_page.dart';

class OnlineLibBottomNavBar extends StatefulWidget {
  final int? openPageByIndex;

  const OnlineLibBottomNavBar({super.key, this.openPageByIndex});

  @override
  State<OnlineLibBottomNavBar> createState() => _OnlineLibBottomNavBarState();
}

class _OnlineLibBottomNavBarState extends State<OnlineLibBottomNavBar> {
  late int _currentIndex;
  Key _navKey = UniqueKey();

  void _goToTab(int index) => setState(() => _currentIndex = index);

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.openPageByIndex ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    final List<Widget> innerPage = [
      HomeLibPage(onTap: () => _goToTab(1), onProfileTap: () => _goToTab(4)),
      UserOnlineBooksLibPage(),
      SizedBox(),
      OfflineBooksLibPage(),
      UserOnlineBookProfileLib(),
    ];
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: innerPage),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
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
          child: GNav(
            key: _navKey,
            selectedIndex: _currentIndex,
            onTabChange: (newIndex) {
              if (newIndex == 2) {
                /// cart sheet
                openMiniAppSheetFamily(
                  context,
                  isTransparent: false,
                  showHandler: false,
                  child: UserOnlineBookCartLibPage(),
                );
                setState(() {
                  _navKey = UniqueKey();
                });
              } else {
                setState(() => _currentIndex = newIndex);
              }
            },
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
              GButton(icon: LineIcons.book, text: localization.myBooks),
              GButton(icon: IconlyLight.buy, text: localization.cart),
              GButton(icon: LineIcons.bookOpen, text: localization.library),
              GButton(icon: IconlyLight.profile, text: localization.profile),
            ],
          ),
        ),
      ),
    );
  }
}
