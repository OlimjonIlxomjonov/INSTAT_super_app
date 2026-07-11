import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';

class CustomAppBarWg extends StatelessWidget implements PreferredSize {
  final String? myTitle;
  final List<Widget>? customActions;
  final PreferredSizeWidget? appBarBottom;
  final bool isFamily;
  final bool showArrow, centerTitle;

  const CustomAppBarWg({
    super.key,
    this.myTitle,
    this.customActions,
    this.appBarBottom,
    this.isFamily = false,
    this.showArrow = true,
    this.centerTitle = true,
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

    return AppBar(
      toolbarHeight: 70,
      leadingWidth: 70,
      actionsPadding: EdgeInsets.only(right: 10),
      leading: showArrow
          ? IconButton(
              style: IconButton.styleFrom(
                backgroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: .circular(50),
                  side: BorderSide(color: AppColors.greyScale.grey200),
                ),
              ),
              onPressed: onClose,
              icon: Icon(IconlyLight.arrow_left_2, size: 20),
            )
          : null,
      automaticallyImplyLeading: false,
      centerTitle: centerTitle,
      titleSpacing: 22,
      title: myTitle != null
          ? Text(myTitle!, style: AppTextStyles.source.semiBold(fontSize: 18))
          : SizedBox.shrink(),
      actions: customActions ?? [SizedBox.shrink()],
      bottom: appBarBottom,
    );
  }

  @override
  Widget get child => throw UnimplementedError();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
