import 'package:family_bottom_sheet/family_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/mini_app_sheet_shell.dart';

class FamilyNavigation {
  static Future<void> familyPush(
    BuildContext context,
    Widget page, {
    bool showHandle = true,
  }) async {
    FamilyModalSheet.of(
      context,
    ).pushPage(MiniAppSheetShell(showHandle: showHandle, child: page));
  }

  static Future<void> familyClose(BuildContext context) async {
    FamilyModalSheet.of(context).popPage();
  }
}
