import 'package:flutter/material.dart';
import 'package:family_bottom_sheet/family_bottom_sheet.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/mini_app_sheet_shell.dart';

Future<T?> openMiniAppSheetFamily<T>(
  BuildContext context, {
  required Widget child,
  bool showHandler = true,
  isTransparent = true,
}) {
  // TDeviceUtils.setStatusBarColor(AppColors.transparent, darkIcons: false);
  return FamilyModalSheet.showMaterialDefault<T>(
    context: context,
    contentBackgroundColor: AppColors.transparent,
    enableDrag: true,
    isDismissible: false,
    useSafeArea: true,
    showDragHandle: false,
    backgroundColor: isTransparent ? AppColors.transparent : AppColors.white,
    builder: (ctx) => MiniAppSheetShell(showHandle: showHandler, child: child),
  );
}
