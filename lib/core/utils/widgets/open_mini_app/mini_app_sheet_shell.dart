import 'package:flutter/material.dart';
import 'package:family_bottom_sheet/family_bottom_sheet.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';

class MiniAppSheetShell extends StatelessWidget {
  const MiniAppSheetShell({
    super.key,
    required this.child,
    this.showHandle = true,
  });

  final Widget child;
  final bool showHandle;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        if (showHandle)
          GestureDetector(
            onVerticalDragEnd: (details) {
              if ((details.primaryVelocity ?? 0) > 600) {
                FamilyModalSheet.of(context).popPage();
              }
            },
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.greyScale.grey300,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}
