import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

Future<void> openMiniAppSheet(
  BuildContext context, {
  required Widget child,
  bool showHandler = false,
}) async {
  TDeviceUtils.setStatusBarColor(Colors.transparent, darkIcons: false);
  return showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    enableDrag: true,
    showDragHandle: false,
    isDismissible: false,
    backgroundColor: Colors.transparent,
    // barrierColor: AppColors.black,
    builder: (_) {
      return SizedBox(
        height: AppResponsiveness.screenHeight - 30,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Material(
            color: Colors.white,
            child: Column(
              children: [
                if (showHandler)
                  Container(
                    margin: .only(top: 20, bottom: 10),
                    width: appW(50),
                    height: appH(3),
                    decoration: BoxDecoration(
                      color: AppColors.greyScale.grey200,
                      borderRadius: .circular(12),
                    ),
                  ),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      );
    },
  );
}
