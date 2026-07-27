import 'package:flutter/material.dart';
import 'package:family_bottom_sheet/family_bottom_sheet.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/mini_app_sheet_shell.dart';

/*
This bottom sheet is the main one which open mini apps,
sections and bunch of others pages inside itself.

It has a function Family.push (has a method custom one => FamilyNavigation)
with this it allows to open the new Pages inside itself without opening a lot of bottomSheets
it really reduces the lags that could be made
by opening bottomSheet inside another one
 */

Future<T?> openMiniAppSheetFamily<T>(
  BuildContext context, {
  required Widget child,
  bool showHandler = true,
  isTransparent = true,
  bool enableDrag = true,
}) {
  return FamilyModalSheet.showMaterialDefault<T>(
    context: context,
    contentBackgroundColor: AppColors.transparent,
    enableDrag: enableDrag,
    barrierColor: AppColors.greyScale.grey100.withValues(alpha: 0.9),
    // barrierColor: AppColors.greyScale.grey50,
    isDismissible: false,
    useSafeArea: false,
    showDragHandle: false,

    backgroundColor: AppColors.transparent,
    builder: (ctx) => MiniAppSheetShell(
      showHandle: showHandler,
      cardBackgroundColor: isTransparent
          ? AppColors.transparent
          : AppColors.white,
      child: child,
    ),
  );
}
