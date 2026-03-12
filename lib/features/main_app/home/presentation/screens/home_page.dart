import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/constants/assets/app_images.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/features/scientific_articles_app/features/articles_bottom_nav_bar.dart';
import 'package:my_template/features/education_app/features/edu_bottom_nav_bar.dart';
import 'package:my_template/features/main_app/home/presentation/screens/components/mobile_ui_screen_component.dart';
import 'package:my_template/features/main_app/home/presentation/screens/components/tablet_ui_screen_component.dart';
import 'package:my_template/features/main_app/home/presentation/screens/drawer/main_app_drawer.dart';
import 'package:my_template/features/main_app/home/presentation/widgets/model/mini_app_model.dart';
import 'package:my_template/features/online_library_app/features/online_lib_bottom_nav_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final localization = AppLocalizations.of(context)!;
    TDeviceUtils.setStatusBarColor(AppColors.white, darkIcons: true);
    TDeviceUtils.systemNavigationBar(AppColors.white);

    final List<MiniAppModel> sections = [
      MiniAppModel(
        mainImage: AppImages.onlineEdu,
        backgroundImage: AppVectors.onlineEduBack,
        title: localization.onlineEducation,
        onTap: (context) {
          openMiniAppSheetFamily(
            context,
            child: EduBottomNavBar(),
            isTransparent: false,
          );
        },
      ),
      MiniAppModel(
        mainImage: AppImages.bookSection,
        backgroundImage: AppVectors.bookSectioBack,
        title: localization.digitalLibrary,
        onTap: (context) {
          openMiniAppSheetFamily(
            // showHandler: false,
            isTransparent: false,
            context,
            child: OnlineLibBottomNavBar(),
          );
        },
      ),
      MiniAppModel(
        mainImage: AppImages.mikroMalumotlar,
        backgroundImage: AppVectors.mikroMalumotlarBack,
        title: localization.microContent,
        onTap: (context) {},
      ),
      MiniAppModel(
        mainImage: AppImages.elektronJurnal,
        backgroundImage: AppVectors.elektronJurnalBack,
        title: localization.electronicJournal,
        onTap: (context) {},
      ),
      MiniAppModel(
        mainImage: AppImages.bookSection,
        backgroundImage: AppVectors.elektronJurnalBack,
        title: 'Ilmiy maqolalar',
        onTap: (context) {
          openMiniAppSheetFamily(
            isTransparent: false,
            context,
            child: ArticlesBottomNavBar(),
          );
        },
      ),
    ];

    /// DEPENDING ON SCREEN SIZE
    return Responsive(
      mobile: Scaffold(
        key: scaffoldKey,
        drawer: MainAppDrawer(),
        body: MobileUiScreenComponent(
          sections: sections,
          scaffoldKey: scaffoldKey,
        ),
      ),
      tablet: Scaffold(
        key: scaffoldKey,
        drawer: MainAppDrawer(),

        /// HEADER LOGO
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
            icon: Icon(Icons.menu),
          ),
          title: SvgPicture.asset(AppVectors.homeInstatLogo),
          centerTitle: false,
          actions: [
            IconButton(onPressed: () {}, icon: Icon(IconlyLight.notification)),
          ],
        ),
        body: TabletUiScreenComponent(sections: sections),
      ),
    );
  }
}
