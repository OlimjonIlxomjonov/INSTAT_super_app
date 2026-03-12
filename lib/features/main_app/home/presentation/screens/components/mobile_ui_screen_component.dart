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

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    void goToPageActiveCourses() {
      openMiniAppSheetFamily(
        context,
        child: DetailedUserBoughtCoursesEduPage(),
      );
    }

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          /// HEADER LOGO
          SliverAppBar(
            floating: true,
            leading: IconButton(
              onPressed: () {
                scaffoldKey.currentState?.openDrawer();
              },
              icon: Icon(Icons.menu),
            ),
            title: SvgPicture.asset(AppVectors.homeInstatLogo),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(IconlyLight.notification),
              ),
            ],
          ),

          /// MINI APP SECTION
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              childAspectRatio: 1.3,
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

          /// SEARCH BAR
          SliverPadding(
            padding: .only(top: 25, bottom: 20),
            sliver: SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              title: AppSearchbarWg(),
            ),
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
              delegate: SliverChildListDelegate([
                ExtendSectionSeeAllWg(
                  title: localization.studyingCourses,
                  onTap: () {
                    openMiniAppSheetFamily(
                      isTransparent: false,
                      context,
                      child: EduBottomNavBar(openPageByIndex: 2),
                    );

                    /// LEAD TO "USER COURSES" PAGE
                  },
                ),
                ActiveCoursesWg(onTap: goToPageActiveCourses),
                ActiveCoursesWg(onTap: goToPageActiveCourses),
                ExtendSectionSeeAllWg(
                  title: localization.popularCourses,
                  onTap: () {
                    openMiniAppSheetFamily(
                      context,
                      child: ShowAllCoursesBottomSheetPage(),
                    );
                  },
                ),
              ]),
            ),
          ),

          /// EDU POPULAR COURSES
          SliverToBoxAdapter(
            child: SizedBox(
              height: appH(280),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: AppPadding.horizontal20x(),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: appW(12)),
                    child: SizedBox(
                      width: appW(300),
                      child: PopularCoursesCardWg(
                        onTap: () => openMiniAppSheetFamily(
                          context,
                          child: DetailedCourseInfoPage(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
