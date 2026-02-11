import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/assets/app_images.dart';
import 'package:my_template/core/utils/constants/assets/app_vectors.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/strings/app_strings.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/active_courses/active_courses_wg.dart';
import 'package:my_template/core/utils/widgets/extend_section/extend_section_see_all_wg.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_serachbar_wg.dart';
import 'package:my_template/features/main_app/home/presentation/widgets/mini_app_section_card.dart';
import 'package:my_template/features/main_app/home/presentation/widgets/model/mini_app_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<MiniAppModel> sections = [
    MiniAppModel(
      mainImage: AppImages.onlineEdu,
      backgroundImage: AppVectors.onlineEduBack,
      title: "Onlayn ta’lim",
    ),
    MiniAppModel(
      mainImage: AppImages.bookSection,
      backgroundImage: AppVectors.bookSectioBack,
      title: "Raqamli kutubxona",
    ),
    MiniAppModel(
      mainImage: AppImages.mikroMalumotlar,
      backgroundImage: AppVectors.mikroMalumotlarBack,
      title: "Mikro ma’lumotlar",
    ),
    MiniAppModel(
      mainImage: AppImages.elektronJurnal,
      backgroundImage: AppVectors.elektronJurnalBack,
      title: "Elektron jurnal",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    TDeviceUtils.setStatusBarColor(AppColors.white);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          /// MAIN APP BAR
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
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              childAspectRatio: 1.3,
            ),
            delegate: SliverChildBuilderDelegate((
              BuildContext context,
              int index,
            ) {
              final item = sections[index];
              return MiniAppSectionCard(
                mainImage: item.mainImage,
                backgroundImage: item.backgroundImage,
                title: item.title,
              );
            }, childCount: 4),
          ),

          SliverAppBar(pinned: true, title: AppSearchbarWg()),

          /// APP BODY FILL REMAINING
          SliverFillRemaining(
            hasScrollBody: false,
            child: SafeArea(
              child: Padding(
                padding: .symmetric(horizontal: appW(20)),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    /// {OQILAYOTGAN KURSLAR}
                    ExtendSectionSeeAllWg(
                      title: AppStrings.studyingCourses,
                      onTap: () {},
                    ),
                    ActiveCoursesWg(),
                    ActiveCoursesWg(),

                    /// {ENG OMMABOP KURSLAR}
                    ExtendSectionSeeAllWg(
                      title: AppStrings.popularCourses,
                      onTap: () {},
                    ),
                    SizedBox(
                      width: appW(300),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: .circular(12),
                                child: Image.asset(
                                  width: appW(300),
                                  height: appH(125),
                                  'assets/home_page/temp_course_card_popular.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: .spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    margin: .only(
                                      left: appW(12),
                                      top: appH(12),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: .circular(12),
                                      color: AppColors.white,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: AppColors.yellow,
                                        ),
                                        Text('4,5'),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    margin: .only(
                                      right: appW(12),
                                      top: appH(12),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: .circular(12),
                                      color: AppColors.white,
                                    ),
                                    child: Icon(IconlyLight.heart),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: appH(12)),
                          Text(
                            'Kategoriya nomi',
                            style: AppTextStyles.source.medium(
                              fontSize: 12,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          SizedBox(height: appH(4)),
                          Text(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            "Uy xo’jaliklarini tanlanma kuzatuvini tashkil etish va o’tkazish",
                            style: AppTextStyles.source.medium(fontSize: 15),
                          ),
                          SizedBox(height: appH(8)),
                          Row(
                            children: [
                              Icon(IconlyLight.time_circle),
                              Text(
                                ' 5 soat 20 daqiqa',
                                style: AppTextStyles.source.regular(
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(width: appW(12)),
                              Icon(IconlyLight.document),
                              Text(
                                ' 12 ta dars',
                                style: AppTextStyles.source.regular(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
