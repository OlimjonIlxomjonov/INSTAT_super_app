import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconly/iconly.dart';
import 'package:line_icons/line_icons.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/home_edu_page.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/screens_edu/stats_edu_page.dart';
import 'package:my_template/features/education_app/features/table_edu/presentation_edu/screens_edu/table_edu_page.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/user_courses_edu_page.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/user_profile_edu.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/home_lib_page.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/presentation_lib/screens_lib/user_online_book_cart_lib_page.dart';
import 'package:my_template/features/online_library_app/features/user_online_books_lib/presentation_lib/screens_lib/user_online_books_lib_page.dart';

class OnlineLibBottomNavBar extends StatefulWidget {
  final int? openPageByIndex;

  const OnlineLibBottomNavBar({super.key, this.openPageByIndex});

  @override
  State<OnlineLibBottomNavBar> createState() => _OnlineLibBottomNavBarState();
}

class _OnlineLibBottomNavBarState extends State<OnlineLibBottomNavBar> {
  late int _currentIndex;

  void _goToTab(int index) => setState(() => _currentIndex = index);

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.openPageByIndex ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> innerPage = [
      HomeLibPage(onTap: () => _goToTab(1)),
      UserOnlineBooksLibPage(),
      UserOnlineBookCartLibPage(),
      UserOnlineBookCartLibPage(),
      UserOnlineBookCartLibPage(),
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
            selectedIndex: _currentIndex,
            onTabChange: (newIndex) => setState(() => _currentIndex = newIndex),
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
              GButton(icon: IconlyLight.home, text: 'Bosh sahifa'),
              GButton(icon: LineIcons.book, text: 'Kitoblarim'),
              GButton(icon: IconlyLight.buy, text: 'Savatcha'),
              GButton(icon: LineIcons.bookOpen, text: 'Kutubxona'),
              GButton(icon: IconlyLight.profile, text: 'Profilim'),
            ],
          ),
        ),
      ),
    );
  }
}
