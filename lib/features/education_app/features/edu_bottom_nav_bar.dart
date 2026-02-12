import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconly/iconly.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/home_edu_page.dart';

class EduBottomNavBar extends StatefulWidget {
  const EduBottomNavBar({super.key});

  @override
  State<EduBottomNavBar> createState() => _EduBottomNavBarState();
}

class _EduBottomNavBarState extends State<EduBottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> eduPages = [
    HomeEduPage(),
    HomeEduPage(),
    HomeEduPage(),
    HomeEduPage(),
    HomeEduPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: eduPages[_currentIndex],
      bottomNavigationBar: Container(
        padding: .symmetric(vertical: 20),
        decoration: BoxDecoration(
          borderRadius: .only(topRight: .circular(24), topLeft: .circular(24)),
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -1),
              color: AppColors.greyScale.grey200,
              spreadRadius: 0,
              blurRadius: 20,
            ),
          ],
        ),
        child: SafeArea(
          child: GNav(
            selectedIndex: _currentIndex,
            onTabChange: (int newIndex) {
              setState(() {
                _currentIndex = newIndex;
              });
            },
            tabBorderRadius: 12,
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 200),
            mainAxisAlignment: .spaceEvenly,
            gap: 8,
            color: AppColors.greyScale.grey600,
            activeColor: AppColors.white,
            iconSize: 24,
            tabBackgroundColor: AppColors.primaryColor,
            padding: EdgeInsets.all(appW(12)),
            tabs: [
              GButton(icon: IconlyLight.home, text: 'Bosh sahifa'),
              GButton(icon: Icons.table_chart_outlined, text: 'Jadval'),
              GButton(icon: LineIcons.book, text: 'Kurslarim'),
              GButton(icon: LineIcons.pieChart, text: 'Statistika'),
              GButton(icon: IconlyLight.profile, text: 'Profilim'),
            ],
          ),
        ),
      ),
    );
  }
}
