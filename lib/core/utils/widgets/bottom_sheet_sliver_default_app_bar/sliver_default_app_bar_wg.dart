import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';

class SliverDefaultAppBarWg extends StatelessWidget {
  final String? myTitle;
  final List<Widget>? customActions;
  final PreferredSizeWidget? appBarBottom;
  final bool isFamily;

  const SliverDefaultAppBarWg({
    super.key,
    this.myTitle,
    this.customActions,
    this.appBarBottom,
    this.isFamily = false,
  });

  @override
  Widget build(BuildContext context) {
    void onClose() {
      if (isFamily) {
        FamilyNavigation.familyClose(context);
      } else {
        AppRoute.close();
      }
    }

    return SliverAppBar(
      toolbarHeight: 70,
      leadingWidth: 70,
      floating: true,
      actionsPadding: EdgeInsets.only(right: 10),
      leading: IconButton(
        style: IconButton.styleFrom(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: .circular(8),
            side: BorderSide(color: AppColors.greyScale.grey200),
          ),
        ),
        onPressed: onClose,
        icon: Icon(IconlyLight.arrow_left_2, size: 20),
      ),
      centerTitle: true,
      title: myTitle != null
          ? Text(myTitle!, style: AppTextStyles.source.semiBold(fontSize: 18))
          : SizedBox.shrink(),
      actions: customActions ?? [SizedBox.shrink()],
      bottom: appBarBottom,
    );
  }
}
