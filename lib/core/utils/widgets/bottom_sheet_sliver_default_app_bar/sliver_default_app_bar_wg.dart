import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class SliverDefaultAppBarWg extends StatelessWidget {
  final String? myTitle;
  final List<Widget>? customActions;
  final PreferredSizeWidget? appBarBottom;

  const SliverDefaultAppBarWg({
    super.key,
    this.myTitle,
    this.customActions,
    this.appBarBottom,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: .only(top: appH(20), left: appW(20), right: appW(20)),
      sliver: SliverAppBar(
        floating: true,
        leading: IconButton(
          style: IconButton.styleFrom(
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: .circular(8),
              side: BorderSide(color: AppColors.greyScale.grey200),
            ),
          ),
          onPressed: () {
            AppRoute.close();
          },
          icon: Icon(IconlyLight.arrow_left_2, size: 20),
        ),
        centerTitle: true,
        title: myTitle != null
            ? Text(myTitle!, style: AppTextStyles.source.semiBold(fontSize: 18))
            : SizedBox.shrink(),
        actions: customActions ?? [SizedBox.shrink()],
        bottom: appBarBottom,
      ),
    );
  }
}
