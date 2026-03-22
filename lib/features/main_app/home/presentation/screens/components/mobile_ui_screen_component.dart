import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/features/education_app/features/edu_bottom_nav_bar.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/detailed_course_info_page.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/show_all_courses_bottom_sheet_page.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/detailed_user_bought_courses_edu_page.dart';
import 'package:my_template/features/main_app/home/presentation/widgets/mini_app_section_card.dart';
import 'package:my_template/features/main_app/home/presentation/widgets/model/mini_app_model.dart';

class MobileUiScreenComponent extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final List<MiniAppModel> sections;

  const MobileUiScreenComponent({
    super.key,
    required this.sections,
    required this.scaffoldKey,
  });

  void _goToPageActiveCourses(BuildContext context) {
    openMiniAppSheetFamily(
      showHandler: false,
      context,
      child: const DetailedUserBoughtCoursesEduPage(),
    );
  }

  void _goToUserCourses(BuildContext context) {
    openMiniAppSheetFamily(
      isTransparent: false,
      context,
      child: const EduBottomNavBar(openPageByIndex: 2),
    );
  }

  void _goToAllCourses(BuildContext context) {
    openMiniAppSheetFamily(
      context,
      child: const ShowAllCoursesBottomSheetPage(),
    );
  }

  void _goToDetailedCourse(BuildContext context) {
    openMiniAppSheetFamily(
      showHandler: false,
      context,
      child: const DetailedCourseInfoPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return CustomScrollView(
      slivers: [
        /// HEADER LOGO
        SliverAppBar(
          snap: true,
          floating: true,
          leading: IconButton(
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
            icon: const Icon(Icons.menu),
          ),
          title: SvgPicture.asset(AppVectors.homeInstatLogo),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(IconlyLight.notification),
            ),
          ],
        ),

        /// MINI APP SECTION
        SliverPadding(
          padding: AppPadding.horizontal20x(),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 2
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1, // 1.3
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = sections[index];
              return MiniAppSectionCard(
                mainImage: item.mainImage,
                backgroundImage: item.backgroundImage,
                title: item.title,
                onTap: item.onTap,
              );
            }, childCount: sections.length),
          ),
        ),

        /// SEARCH BAR
        SliverAppBar(
          toolbarHeight: 56 + 24,
          pinned: true,
          automaticallyImplyLeading: false,
          titleSpacing: 20,
          title: const AppSearchbarWg(),
        ),

        /// BANNERS
        SliverToBoxAdapter(
          child: Container(
            margin: AppPadding.horizontal20x(),
            width: double.infinity,
            height: 200,
            color: AppColors.greyScale.grey400,
            child: Center(child: Text('PLACEHOLDER')),
          ),
        ),

        /// EDU ACTIVE COURSES
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: appW(20)),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              switch (index) {
                case 0:
                  return ExtendSectionSeeAllWg(
                    title: localization.studyingCourses,
                    onTap: () {
                      _goToUserCourses(context);
                    },
                  );
                case 1:
                  return ActiveCoursesWg(
                    onTap: () => _goToPageActiveCourses(context),
                  );
                case 2:
                  return ActiveCoursesWg(
                    onTap: () => _goToPageActiveCourses(context),
                  );
                case 3:
                  return ExtendSectionSeeAllWg(
                    title: localization.popularCourses,
                    onTap: () {
                      _goToAllCourses(context);
                    },
                  );
                default:
                  return const SizedBox.shrink();
              }
            }, childCount: 4),
          ),
        ),

        /// EDU POPULAR COURSES
        SliverSafeArea(
          top: false,
          sliver: SliverToBoxAdapter(
            child: SizedBox(
              height: appH(280),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: AppPadding.horizontal20x(),
                itemCount: 10,
                cacheExtent: appW(300),
                itemExtent: appW(312),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: appW(12)),
                    child: PopularCoursesCardWg(
                      onTap: () => _goToDetailedCourse(context),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
