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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late List<MiniAppModel> _sections;

  void _openEduApp(BuildContext context) {
    openMiniAppSheetFamily(
      context,
      child: const EduBottomNavBar(),
      isTransparent: false,
      showHandler: false,
    );
  }

  void _openOnlineLibraryApp(BuildContext context) {
    openMiniAppSheetFamily(
      showHandler: false,
      isTransparent: false,
      context,
      child: const OnlineLibBottomNavBar(),
    );
  }

  void _openArticlesApp(BuildContext context) {
    openMiniAppSheetFamily(
      isTransparent: false,
      showHandler: false,
      context,
      child: const ArticlesBottomNavBar(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(const AssetImage(AppImages.onlineEdu), context);
    precacheImage(const AssetImage(AppImages.bookSection), context);
    precacheImage(const AssetImage(AppImages.mikroMalumotlar), context);
    precacheImage(const AssetImage(AppImages.elektronJurnal), context);

    final localization = AppLocalizations.of(context)!;

    _sections = [
      MiniAppModel(
        mainImage: AppImages.onlineEdu,
        backgroundImage: AppVectors.onlineEduBack,
        title: localization.onlineEducation,
        onTap: (context) => _openEduApp(context),
      ),
      MiniAppModel(
        mainImage: AppImages.bookSection,
        backgroundImage: AppVectors.bookSectioBack,
        title: localization.digitalLibrary,
        onTap: (context) => _openOnlineLibraryApp(context),
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
        onTap: (context) => _openArticlesApp(context),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    /// DEPENDING ON SCREEN SIZE & Orientation
    return Responsive(
      mobile: Scaffold(
        key: scaffoldKey,
        drawer: const MainAppDrawer(),
        body: MobileUiScreenComponent(
          sections: _sections,
          scaffoldKey: scaffoldKey,
        ),
      ),
      tablet: Scaffold(
        key: scaffoldKey,
        drawer: const MainAppDrawer(),

        /// HEADER LOGO
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(Icons.menu),
          ),
          title: SvgPicture.asset(AppVectors.homeInstatLogo),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(IconlyLight.notification),
            ),
          ],
        ),
        body: TabletUiScreenComponent(sections: _sections),
      ),
    );
  }
}
