import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

Future<void> customBottomSheetWg(
  BuildContext context, {
  required Widget child,
}) async {
  return showModalBottomSheet(
    isScrollControlled: true,
    useSafeArea: true,
    context: context,
    builder: (context) {
      return SizedBox(
        height: AppResponsiveness.screenHeight - 30,
        child: SafeArea(
          child: Column(
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
              Expanded(child: child),
            ],
          ),
        ),
      );
    },
  );
}
