import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/features/education_app/features/edu_bottom_nav_bar.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/show_all_courses_bottom_sheet_page.dart';
import 'package:my_template/features/main_app/home/presentation/widgets/mini_app_section_card.dart';
import 'package:my_template/features/main_app/home/presentation/widgets/model/mini_app_model.dart';

class TabletUiScreenComponent extends StatelessWidget {
  final List<MiniAppModel> sections;

  const TabletUiScreenComponent({super.key, required this.sections});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    void goToPageActiveCourses() {
      // openMiniAppSheetFamily(
      //   context,
      //   child: DetailedUserBoughtCoursesEduPage(),
      // );
    }

    return SafeArea(
      child: OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;
          return Row(
            crossAxisAlignment: .start,
            children: [
              /// LEFT SIDE BAR
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /// MINI APP SECTION
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0,
                          childAspectRatio: 1.3,
                        ),
                        itemCount: sections.length,
                        itemBuilder: (context, index) {
                          final item = sections[index];

                          return MiniAppSectionCard(
                            mainImage: item.mainImage,
                            backgroundImage: item.backgroundImage,
                            title: item.title,
                            onTap: item.onTap,
                            onLongPress: () {}, isCollapsed: false,
                          );
                        },
                      ),
                      if (!isPortrait)
                        /// SEARCH BAR
                        Padding(
                          padding: AppPadding.hAndV20x20(),
                          child: AppSearchbarWg(),
                        ),
                      if (!isPortrait)
                        /// BANNERS
                        Container(
                          margin: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 20,
                          ),
                          width: double.infinity,
                          height: 200,
                          color: AppColors.greyScale.grey400,
                          child: Center(child: Text('PLACEHOLDER')),
                        ),
                    ],
                  ),
                ),
              ),

              /// RIGHT CONTENT SIDE BAR
              Expanded(
                flex: isPortrait ? 3 : 2,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (isPortrait)
                        /// SEARCH BAR
                        Padding(
                          padding: AppPadding.hAndV20x20(),
                          child: AppSearchbarWg(),
                        ),

                      if (isPortrait)
                        /// BANNERS
                        Container(
                          margin: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 20,
                          ),
                          width: double.infinity,
                          height: 200,
                          color: AppColors.greyScale.grey400,
                          child: Center(child: Text('PLACEHOLDER')),
                        ),

                      /// EDU ACTIVE COURSES
                      Column(
                        children: [
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
                          // ActiveCoursesWg(onTap: goToPageActiveCourses),
                          // ActiveCoursesWg(onTap: goToPageActiveCourses),
                          ExtendSectionSeeAllWg(
                            title: localization.popularCourses,
                            onTap: () {
                              openMiniAppSheetFamily(
                                context,
                                child: ShowAllCoursesBottomSheetPage(),
                              );
                            },
                          ),
                        ],
                      ),

                      /// EDU POPULAR COURSES
                      // SizedBox(
                      //   height: !isPortrait ? 320 : 400,
                      //   child: ListView.builder(
                      //     scrollDirection: Axis.horizontal,
                      //     padding: AppPadding.horizontal20x(),
                      //     itemCount: 10,
                      //     itemBuilder: (context, index) {
                      //       return Padding(
                      //         padding: EdgeInsets.only(right: 12),
                      //         child: SizedBox(
                      //           width: 400,
                      //           child: PopularCoursesCardWg(
                      //             onTap: () => openMiniAppSheetFamily(
                      //               context,
                      //               child: DetailedCourseInfoPage(),
                      //             ),
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
