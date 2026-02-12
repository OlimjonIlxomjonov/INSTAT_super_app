import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class PopularCoursesCardWg extends StatelessWidget {
  const PopularCoursesCardWg({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: .only(left: appW(12), top: appH(12)),
                    decoration: BoxDecoration(
                      borderRadius: .circular(12),
                      color: AppColors.white,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: AppColors.yellow),
                        Text('4,5'),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: .only(right: appW(12), top: appH(12)),
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
                style: AppTextStyles.source.regular(fontSize: 13),
              ),
              SizedBox(width: appW(12)),
              Icon(IconlyLight.document),
              Text(
                ' 12 ta dars',
                style: AppTextStyles.source.regular(fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
