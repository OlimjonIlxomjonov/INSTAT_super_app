import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';

Future<void> subBottomSheetOpener(
  BuildContext context, {
  required Widget child,
}) async {
  TDeviceUtils.setStatusBarColor(Colors.white, darkIcons: false);

  return showModalBottomSheet(
    context: context,
    enableDrag: true,
    isDismissible: false,
    useSafeArea: true,
    isScrollControlled: true,
    showDragHandle: false,
    backgroundColor: AppColors.transparent,
    builder: (context) {
      return Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: .symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.greyScale.grey300,
              borderRadius: .circular(30),
            ),
          ),
          Expanded(
            child: ClipRRect(borderRadius: .circular(20), child: child),
          ),
        ],
      );
    },
  );
}
