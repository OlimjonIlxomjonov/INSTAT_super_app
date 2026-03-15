import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconly/iconly.dart';
import 'package:line_icons/line_icons.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/screens/articles_home_page.dart';
import 'package:my_template/features/scientific_articles_app/features/magazines/presentation/sreens/magazines_page.dart';
import 'package:my_template/features/scientific_articles_app/features/profile/presentation/screens/articles_profile_page.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/screens/add_article/add_article_page.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/screens/user_articles_page.dart';

class ArticlesBottomNavBar extends StatefulWidget {
  final int? openPageByIndex;

  const ArticlesBottomNavBar({super.key, this.openPageByIndex});

  @override
  State<ArticlesBottomNavBar> createState() => _ArticlesBottomNavBarState();
}

class _ArticlesBottomNavBarState extends State<ArticlesBottomNavBar> {
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

    final List<Widget> eduPages = [
      ArticlesHomePage(
        onProfileTap: () => _goToTab(3),
        toArticlesPage: () => _goToTab(2),
      ),
      MagazinesPage(),
      SizedBox(),
      ArticlesProfilePage(),
    ];
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: eduPages),
      bottomNavigationBar: Column(
        mainAxisSize: .min,
        children: [
          Container(
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
                    openMiniAppSheetFamily(
                      showHandler: false,
                      context,
                      child: UserArticlesPage(),
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
                  GButton(icon: LineIcons.book, text: 'Jurnallar'),
                  GButton(icon: LineIcons.edit, text: 'Maqolalar'),
                  GButton(
                    icon: IconlyLight.profile,
                    text: localization.profile,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
