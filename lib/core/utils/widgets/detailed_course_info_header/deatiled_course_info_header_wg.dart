import 'package:family_bottom_sheet/family_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class DetailedCourseInfoHeaderWg extends StatelessWidget {
  const DetailedCourseInfoHeaderWg({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          /// HEADER IMAGE WITH ARROW BACK
          Stack(
            children: [
              Image.asset(
                height: appH(320),
                width: double.infinity,
                'assets/home_page/temp_course_dummy.png',
                fit: BoxFit.cover,
              ),
              Padding(
                padding: .only(left: appW(10), top: appH(10)),
                child: IconButton(
                  onPressed: () {
                    // AppRoute.close();
                    FamilyModalSheet.of(context).popPage();
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(borderRadius: .circular(8)),
                  ),
                  icon: Icon(IconlyLight.arrow_left_2, size: 20),
                ),
              ),
            ],
          ),

          /// BODY STARTER CONTENT
          Padding(
            padding: .fromLTRB(appW(20), appH(16), appW(20), 0),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  'Kotegoriya nomi',
                  style: AppTextStyles.source.medium(
                    fontSize: 13,
                    color: AppColors.greyScale.grey600,
                  ),
                ),
                SizedBox(height: appH(8)),
                Text(
                  'Statistika (Tarmoqlar va sohalar bo’yicha)',
                  style: AppTextStyles.source.semiBold(fontSize: 17),
                ),
                SizedBox(height: appH(12)),
                Row(
                  children: [
                    Icon(Icons.star, color: AppColors.orange),
                    Text(
                      ' 5',
                      style: AppTextStyles.source.medium(
                        fontSize: 13,
                        color: AppColors.greyScale.grey600,
                      ),
                    ),
                    SizedBox(width: appH(12)),
                    Icon(
                      IconlyLight.document,
                      color: AppColors.greyScale.grey600,
                    ),
                    Text(
                      ' 12 ta',
                      style: AppTextStyles.source.medium(
                        fontSize: 13,
                        color: AppColors.greyScale.grey600,
                      ),
                    ),
                    SizedBox(width: appH(12)),
                    Icon(
                      IconlyLight.time_circle,
                      color: AppColors.greyScale.grey600,
                    ),
                    Text(
                      ' 5 soat',
                      style: AppTextStyles.source.medium(
                        fontSize: 13,
                        color: AppColors.greyScale.grey600,
                      ),
                    ),
                  ],
                ),

                /// DESCRIPTION CARD
                Container(
                  margin: .only(top: appH(16)),
                  padding: .all(12),
                  decoration: BoxDecoration(
                    borderRadius: .circular(12),
                    border: .all(color: AppColors.greyScale.grey200),
                  ),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        'Izoh',
                        style: AppTextStyles.source.medium(fontSize: 16),
                      ),
                      SizedBox(height: appH(8)),
                      Text(
                        "This course is carefully crafted to take you on a complete learning journey—from understanding the core principles of design to building real-world projects that showcase your skills. Whether you're an aspiring designer, a developer looking to understand design better, or an entrepreneur who wants to build intuitive digital products, this course will give you both the mindset and the practical tools you need.",
                        style: AppTextStyles.source.regular(
                          fontSize: 13,
                          color: AppColors.greyScale.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
