import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/general_widgets/bottom_nav_bar_custom_mini_app/bottom_nav_bar_custom_mini_app.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/screens/articles_home_page.dart';
import 'package:my_template/features/scientific_articles_app/features/magazines/presentation/sreens/magazines_page.dart';
import 'package:my_template/features/scientific_articles_app/features/profile/presentation/screens/articles_profile_page.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/screens/user_articles_page.dart';

class ArticlesBottomNavBar extends StatelessWidget {
  final int? openPageByIndex;

  const ArticlesBottomNavBar({super.key, this.openPageByIndex});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    
    return BottomNavBarCustomMiniApp(
      openPageByIndex: openPageByIndex,
      onTabChangeOverride: (ctx, newIndex) {
        if (newIndex == 2) {
          openMiniAppSheetFamily(
            showHandler: false,
            ctx,
            child: const UserArticlesPage(),
          );
          return true; // Ignore tab change
        }
        return false;
      },
      innerPageBuilder: (goToTab) => [
        ArticlesHomePage(
          onProfileTap: () => goToTab(3),
          toArticlesPage: () => goToTab(2),
        ),
        const MagazinesPage(),
        const SizedBox(),
        const ArticlesProfilePage(),
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
          label: 'Jurnallar',
        ),
        MiniAppBottomNavTabItem(
          icon: Icons.article_outlined,
          activeIcon: Icons.article,
          label: 'Maqolalar',
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
