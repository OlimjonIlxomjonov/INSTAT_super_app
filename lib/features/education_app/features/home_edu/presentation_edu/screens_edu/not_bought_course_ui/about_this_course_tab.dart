import 'package:family_bottom_sheet/family_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/extend_section/extend_section_see_all_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/mini_app_sheet_shell.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sub_bottom_sheet_opener.dart';
import 'package:my_template/core/utils/widgets/popular_courses_card/popular_courses_card_wg.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/detailed_course_info_page.dart';

class AboutThisCourseTab extends StatelessWidget {
  const AboutThisCourseTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: .only(bottom: 20),
      children: [
        /// STUDIES // TITLES
        Container(
          margin: .only(bottom: appH(16), left: appW(20), right: appW(20)),
          padding: .all(12),
          decoration: BoxDecoration(
            borderRadius: .circular(12),
            border: .all(color: AppColors.greyScale.grey200),
          ),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                'Nimalarni o’rganasiz!',
                style: AppTextStyles.source.medium(fontSize: 16),
              ),
              ...List.generate(
                10,
                (index) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.check_circle,
                    color: AppColors.primaryColor,
                  ),
                  title: Text(
                    'Iqtisodiyot tarmoqlari bo‘yicha asosiy statistik ko‘rsatkichlarni tahlil qilish',
                    style: AppTextStyles.source.regular(
                      fontSize: 14,
                      color: AppColors.greyScale.grey500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        /// SIMILAR COURSES
        Padding(
          padding: .symmetric(horizontal: appW(20)),
          child: ExtendSectionSeeAllWg(title: "O’xshash kurslar", onTap: () {}),
        ),
        SizedBox(
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
                    onTap: () {
                      // openMiniAppSheet(
                      //   context,
                      //   child: DetailedCourseInfoPage(),
                      // );

                      // subBottomSheetOpener(
                      //   context,
                      //   child: DetailedCourseInfoPage(),
                      // );

                      FamilyModalSheet.of(context).pushPage(
                        MiniAppSheetShell(
                          child: const DetailedCourseInfoPage(),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
