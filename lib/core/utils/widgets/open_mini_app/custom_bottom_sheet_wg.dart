import 'package:flutter/material.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';

Future<void> customBottomSheetWg(
  BuildContext context, {
  required Widget child,
}) async {
  TDeviceUtils.setStatusBarColor(Colors.transparent, darkIcons: false);

  return showModalBottomSheet(
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    context: context,
    builder: (context) {
      return SafeArea(child: ListView(shrinkWrap: true, children: [child]));
    },
  );
}
