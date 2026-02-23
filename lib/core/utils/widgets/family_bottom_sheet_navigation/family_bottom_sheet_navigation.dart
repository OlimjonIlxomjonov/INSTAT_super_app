import 'package:family_bottom_sheet/family_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/mini_app_sheet_shell.dart';

class FamilyNavigation {
  static Future<void> familyPush(context, Widget page) async {
    FamilyModalSheet.of(context).pushPage(MiniAppSheetShell(child: page));
  }

  static Future<void> familyClose(context) async {
    FamilyModalSheet.of(context).popPage();
  }
}
