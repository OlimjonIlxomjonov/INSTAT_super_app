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
  });

  final Widget child;
  final bool showHandle;

  @override
  State<MiniAppSheetShell> createState() => _MiniAppSheetShellState();
}

class _MiniAppSheetShellState extends State<MiniAppSheetShell> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
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
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
