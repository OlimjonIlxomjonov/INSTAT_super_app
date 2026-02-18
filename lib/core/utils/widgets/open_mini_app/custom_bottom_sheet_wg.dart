import 'package:flutter/material.dart';

Future<void> customBottomSheetWg(
  BuildContext context, {
  required Widget child,
}) async {

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
