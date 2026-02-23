import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/widgets/detailed_online_book_header_items_wg.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/widgets/vertical_divider_wg.dart';

class DetailedOnlineBookHeaderWg extends StatelessWidget {
  const DetailedOnlineBookHeaderWg({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: .circular(20),
        gradient: LinearGradient(
          colors: [AppColors.white, AppColors.greyScale.grey100],
          stops: [0.3, 0.6],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: .circular(12),
            child: Image.asset(
              'assets/images/temp_book.jpg',
              fit: BoxFit.contain,
              height: 300,
            ),
          ),
          SizedBox(height: appH(16)),
          Container(
            margin: .only(bottom: 8),
            padding: .symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: .circular(6),
              color: AppColors.greyScale.grey200,
            ),
            child: Text(
              'Roman',
              style: AppTextStyles.source.medium(fontSize: 13),
            ),
          ),
          Text(
            'Motivatsiya formulasi',
            style: AppTextStyles.source.medium(fontSize: 22),
          ),
          SizedBox(height: appH(8)),
          Text(
            'Brendon Burchard',
            style: AppTextStyles.source.regular(fontSize: 13),
          ),
          SizedBox(height: appH(20)),

          Row(
            mainAxisAlignment: .spaceEvenly,
            children: const [
              DetailedOnlineBookHeaderItemsWg(
                value: '4.7',
                label: 'Rating',
                icon: Icons.star,
              ),
              VerticalDividerWg(),
              DetailedOnlineBookHeaderItemsWg(value: '356', label: 'Sahifa'),
              VerticalDividerWg(),
              DetailedOnlineBookHeaderItemsWg(value: '245', label: 'Sotuv'),
              VerticalDividerWg(),
              DetailedOnlineBookHeaderItemsWg(value: '9.4MB', label: "O'lcham"),
            ],
          ),
        ],
      ),
    );
  }
}
