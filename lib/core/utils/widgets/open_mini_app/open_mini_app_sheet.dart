import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

Future<void> openMiniAppSheet(BuildContext context, {required Widget child}) {
  return showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    enableDrag: true,
    showDragHandle: false,
    isDismissible: false,
    backgroundColor: Colors.transparent,
    barrierColor: AppColors.greyScale.grey200.withValues(alpha: 0.8),
    builder: (_) {
      return SizedBox(
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Material(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(height: appH(100), child: Text('Test')),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      );
    },
  );
}
