import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/general_widgets/online_book_wg/short_book_details_wg.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';

class UserOnlineBookCartLibPage extends StatelessWidget {
  const UserOnlineBookCartLibPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverDefaultAppBarWg(myTitle: 'Savat'),
          SliverPadding(
            padding: AppPadding.hAndV20x20(),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  ShortBookDetailsWg(
                    bookName: 'Motivatsiya formulasi',
                    bookAuthor: 'Brendon Burchard',
                    newPrice: '469 000 UZS',
                    oldPrice: '510 000 UZS',
                  ),
                  SizedBox(height: appH(20)),
                  ShortBookDetailsWg(
                    bookName: 'Motivatsiya formulasi',
                    bookAuthor: 'Brendon Burchard',
                    newPrice: '469 000 UZS',
                    oldPrice: '510 000 UZS',
                  ),

                  SizedBox(height: appH(30)),
                  _buildSimpleRow('Umumiy mahsulotlar', '2 ta'),
                  SizedBox(height: 12),
                  _buildSimpleRow('Chegirma', '90 00 000 UZS'),
                  SizedBox(height: 16),
                  Divider(color: AppColors.greyScale.grey200),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        'Umumiy summa',
                        style: AppTextStyles.source.medium(fontSize: 17),
                      ),
                      Text(
                        '960 000 UZS',
                        style: AppTextStyles.source.medium(fontSize: 17),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: CustomBottomNavContainerWg(
        buttonText: 'Sotib olish - 960 000 UZS',
        onTap: () {},
      ),
    );
  }

  Row _buildSimpleRow(String title, trailText) => Row(
    mainAxisAlignment: .spaceBetween,
    children: [
      Text(title, style: AppTextStyles.source.regular(fontSize: 15)),
      Text(trailText, style: AppTextStyles.source.regular(fontSize: 15)),
    ],
  );
}
