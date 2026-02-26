import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';

Future<void> subBottomSheetOpener(
  BuildContext context, {
  required Widget child,
  required bool isExpanded,
}) async {
  return showModalBottomSheet(
    context: context,
    enableDrag: true,
    isDismissible: false,
    useSafeArea: true,
    isScrollControlled: true,
    showDragHandle: false,
    backgroundColor: AppColors.white,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: .min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: .symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: AppColors.greyScale.grey300,
                borderRadius: .circular(30),
              ),
            ),
            if (isExpanded)
              Expanded(
                child: ClipRRect(borderRadius: .circular(20), child: child),
              )
            else
              ClipRRect(borderRadius: .circular(20), child: child),
          ],
        ),
      );
    },
  );
}
