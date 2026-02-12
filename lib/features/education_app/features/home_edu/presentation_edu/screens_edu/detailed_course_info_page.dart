import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class DetailedCourseInfoPage extends StatelessWidget {
  const DetailedCourseInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
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
                        onPressed: () {},
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: .circular(8),
                          ),
                        ),
                        icon: Icon(IconlyLight.arrow_left_2, size: 20),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: .fromLTRB(appW(20), appH(16), appW(20), 0),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text('Kotegoriya nomi'),
                      Text('Statistika (Tarmoqlar va sohalar bo’yicha)'),
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
