import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/features/main_app/home/presentation/screens/home_page.dart';
import 'package:my_template/features/settings/presentation/screens/settings_page.dart';

class AppBottomNavBar extends StatefulWidget {
  const AppBottomNavBar({super.key});

  @override
  State<AppBottomNavBar> createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends State<AppBottomNavBar> {
  /// {INITIAL BOTTOM NAV INDEX = STARTER}
  int _initialIndex = 0;

  /// {PAGES}
  final List<Widget> pages = [HomePage(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_initialIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.transparent,
        selectedIndex: _initialIndex,
        elevation: 0,
        onDestinationSelected: (index) {
          setState(() {
            _initialIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            selectedIcon: Icon(
              IconlyBold.home,
              color: AppColors.greyScale.grey600,
            ),
            icon: Icon(IconlyLight.home),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              IconlyBold.setting,
              color: AppColors.greyScale.grey600,
            ),
            icon: Icon(IconlyLight.setting),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
