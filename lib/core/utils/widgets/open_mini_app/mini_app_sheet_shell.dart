import 'package:flutter/material.dart';
import 'package:family_bottom_sheet/family_bottom_sheet.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/general_widgets/mini_app_home_header/mini_app_home_header_wg.dart';

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
      height: MediaQuery.of(context).size.height / 1.1,
      child: Column(
        // mainAxisSize: .min,
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

          /// HEADER
          // if (widget.showHandle)
          //   Padding(
          //     padding: AppPadding.hAndV20x20(),
          //     child: AppBar(
          //       leading: GestureDetector(
          //         onTap: () {},
          //         child: CircleAvatar(
          //           backgroundColor: AppColors.greyScale.grey300,
          //         ),
          //       ),
          //       title: GestureDetector(
          //         onTap: () {},
          //         child: Column(
          //           crossAxisAlignment: .start,
          //           children: [
          //             Text(
          //               'Hayrli kun! ✌️',
          //               style: AppTextStyles.source.regular(fontSize: 14),
          //             ),
          //             Text(
          //               'Afzal Pulatov',
          //               style: AppTextStyles.source.medium(fontSize: 16),
          //             ),
          //           ],
          //         ),
          //       ),
          //       actions: [Icon(IconlyLight.notification)],
          //     ),
          //   ),
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
