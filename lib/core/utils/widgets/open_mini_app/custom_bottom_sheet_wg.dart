import 'package:flutter/material.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

Future<void> customBottomSheetWg(
  BuildContext context, {
  required Widget child,
}) {
  return showModalBottomSheet(
    showDragHandle: true,
    isScrollControlled: true,
    useSafeArea: true,
    context: context,
    builder: (context) {
      return SizedBox(
        height: AppResponsiveness.screenHeight - 100,
        child: Column(children: [Expanded(child: child)]),
      );
    },
  );
}
