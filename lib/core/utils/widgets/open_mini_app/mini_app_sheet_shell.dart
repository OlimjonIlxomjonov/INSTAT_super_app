import 'package:flutter/material.dart';
import 'package:family_bottom_sheet/family_bottom_sheet.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';

/*
  Design for OpenMiniAppPackageFamily, here is the all custom design happening
 */

class MiniAppSheetShell extends StatefulWidget {
  const MiniAppSheetShell({
    super.key,
    required this.child,
    this.showHandle = true,
    this.cardBackgroundColor = AppColors.transparent,
  });

  final Widget child;
  final bool showHandle;

  final Color cardBackgroundColor;

  @override
  State<MiniAppSheetShell> createState() => _MiniAppSheetShellState();
}

class _MiniAppSheetShellState extends State<MiniAppSheetShell> {
  @override
  Widget build(BuildContext context) {
    final topInset = MediaQueryData.fromView(View.of(context)).padding.top;

    final designMargin = widget.showHandle ? 10.0 : 0.0;

    return Padding(
      padding: EdgeInsets.only(top: topInset + designMargin),
      child: Column(
        children: [
          if (widget.showHandle)
            GestureDetector(
              onVerticalDragEnd: (details) {
                if ((details.primaryVelocity ?? 0) > 600) {
                  FamilyModalSheet.of(context).popPage();
                }
              },
              child: Container(
                width: 40,
                height: 4,
                margin: const .only(top: 10, bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.greyScale.grey300,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: .circular(30)),
              child: ColoredBox(
                color: widget.cardBackgroundColor,
                child: widget.child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
