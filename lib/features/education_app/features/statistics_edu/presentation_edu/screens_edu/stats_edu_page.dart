import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_serachbar_wg.dart';

class StatsEduPage extends StatelessWidget {
  const StatsEduPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverDefaultAppBarWg(myTitle: "Foydalanuvchilar"),
          SliverPadding(
            padding: AppPadding.hAndV20x20(),
            sliver: SliverToBoxAdapter(child: AppSearchbarWg()),
          ),

          /// USERS LEADERBOARD
          SliverToBoxAdapter(
            child: Column(
              children: List.generate(10, (index) {
                return Container(
                  margin: .only(
                    left: appW(20),
                    right: appW(20),
                    bottom: appH(12),
                  ),
                  padding: .symmetric(horizontal: appW(12), vertical: appH(8)),
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
                              style: AppTextStyles.source.medium(fontSize: 14),
                            ),
                            Text(
                              'afzal777@gmail.com',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.source.regular(fontSize: 12),
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
        ],
      ),
    );
  }
}
