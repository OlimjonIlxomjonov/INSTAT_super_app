import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class MiniAppHomeHeaderWg extends StatelessWidget {
  const MiniAppHomeHeaderWg({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: .only(left: appW(20), right: appW(20)),
      sliver: SliverAppBar(
        leading: CircleAvatar(backgroundColor: AppColors.greyScale.grey300),
        title: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              'Hayrli kun! ✌️',
              style: AppTextStyles.source.regular(fontSize: 14),
            ),
            Text(
              'Afzal Pulatov',
              style: AppTextStyles.source.medium(fontSize: 16),
            ),
          ],
        ),
        actions: [Icon(IconlyLight.notification)],
      ),
    );
  }
}
