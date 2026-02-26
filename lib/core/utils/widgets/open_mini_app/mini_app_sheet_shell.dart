import 'package:flutter/material.dart';
import 'package:family_bottom_sheet/family_bottom_sheet.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

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
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.05,
      child: Column(
        mainAxisSize: .min,
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
                margin: .only(top: 10, bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.greyScale.grey300,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: .circular(20)),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
