import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/assets/app_images.dart';
import 'package:my_template/core/utils/constants/assets/app_vectors.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/strings/app_strings.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/active_courses/active_courses_wg.dart';
import 'package:my_template/core/utils/widgets/extend_section/extend_section_see_all_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_sheet.dart';
import 'package:my_template/core/utils/widgets/popular_courses_card/popular_courses_card_wg.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_serachbar_wg.dart';
import 'package:my_template/features/education_app/features/edu_bottom_nav_bar.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/detailed_course_info_page.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/home_edu_page.dart';
import 'package:my_template/features/main_app/home/presentation/widgets/mini_app_section_card.dart';
import 'package:my_template/features/main_app/home/presentation/widgets/model/mini_app_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MiniAppModel> sections = [
      MiniAppModel(
        mainImage: AppImages.onlineEdu,
        backgroundImage: AppVectors.onlineEduBack,
        title: "Onlayn ta’lim",
        onTap: (context) {
          openMiniAppSheet(context, child: EduBottomNavBar());
        },
      ),
      MiniAppModel(
        mainImage: AppImages.bookSection,
        backgroundImage: AppVectors.bookSectioBack,
        title: "Raqamli kutubxona",
        onTap: (context) {},
      ),
      MiniAppModel(
        mainImage: AppImages.mikroMalumotlar,
        backgroundImage: AppVectors.mikroMalumotlarBack,
        title: "Mikro ma’lumotlar",
        onTap: (context) {},
      ),
      MiniAppModel(
        mainImage: AppImages.elektronJurnal,
        backgroundImage: AppVectors.elektronJurnalBack,
        title: "Elektron jurnal",
        onTap: (context) {},
      ),
    ];

    TDeviceUtils.setStatusBarColor(AppColors.white);
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: Icon(Icons.menu),
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

            SliverPadding(
              padding: .only(top: appH(25), bottom: appH(20)),
              sliver: SliverAppBar(pinned: true, title: AppSearchbarWg()),
            ),

            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: appW(20)),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  ExtendSectionSeeAllWg(
                    title: AppStrings.studyingCourses,
                    onTap: () {},
                  ),
                  ActiveCoursesWg(),
                  ActiveCoursesWg(),

                  ExtendSectionSeeAllWg(
                    title: AppStrings.popularCourses,
                    onTap: () {},
                  ),
                ]),
              ),
            ),

            SliverToBoxAdapter(
              child: SizedBox(
                height: appH(250),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: appW(20)),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: appW(12)),
                      child: SizedBox(
                        width: appW(300),
                        child: PopularCoursesCardWg(
                          onTap: () => openMiniAppSheet(
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
          ],
        ),
      ),
    );
  }
}
