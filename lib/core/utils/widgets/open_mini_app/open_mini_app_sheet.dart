import 'package:flutter/material.dart';

Future<void> openMiniAppSheet(BuildContext context, {required Widget child}) {
  return showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    enableDrag: false,
    isDismissible: false,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Material(
          color: Colors.white,
          child: Column(children: [Expanded(child: child)]),
        ),
      );
    },
  );
}
