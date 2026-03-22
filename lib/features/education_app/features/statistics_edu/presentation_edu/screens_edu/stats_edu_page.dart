import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_serachbar_wg.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/screens_edu/temp_detailed_user_edu.dart';

class StatsEduPage extends StatelessWidget {
  const StatsEduPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWg(myTitle: 'Foydalanuvchilar'),
      body: CustomScrollView(
        slivers: [
          // SliverDefaultAppBarWg(myTitle: "Foydalanuvchilar"),
          SliverPadding(
            padding: AppPadding.hAndV20x20(),
            sliver: SliverToBoxAdapter(child: AppSearchbarWg()),
          ),

          /// USERS LEADERBOARD
          SliverToBoxAdapter(
            child: GestureDetector(
              onTap: () {
                openMiniAppSheetFamily(
                  context,
                  showHandler: false,
                  child: TempDetailedUserEdu(),
                );
              },
              child: Column(
                children: List.generate(10, (index) {
                  return Container(
                    margin: .only(
                      left: appW(20),
                      right: appW(20),
                      bottom: appH(12),
                    ),
                    padding: .symmetric(
                      horizontal: appW(12),
                      vertical: appH(8),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: .circular(12),
                      border: .all(color: AppColors.greyScale.grey200),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '#$index',
                          style: AppTextStyles.source.regular(
                            fontSize: 13,
                            color: AppColors.greyScale.grey600,
                          ),
                        ),
                        SizedBox(width: appW(10)),
                        CircleAvatar(radius: 30),
                        SizedBox(width: appW(12)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              Text(
                                'Afzal Pulatov',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.source.medium(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'afzal777@gmail.com',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.source.regular(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: appW(12)),
                        Text(
                          '3,256',
                          style: AppTextStyles.source.medium(fontSize: 13),
                        ),
                        Icon(Icons.star, size: 20, color: AppColors.orange),
                        SizedBox(width: appW(12)),
                        Icon(IconlyLight.arrow_right_2),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
