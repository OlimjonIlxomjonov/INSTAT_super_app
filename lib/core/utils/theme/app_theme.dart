import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/theme/custom_themes/app_bar_theme.dart';
import 'package:my_template/core/utils/theme/custom_themes/app_text_theme.dart';
import 'package:my_template/core/utils/theme/custom_themes/elevatedbutton_theme.dart';
import 'package:my_template/core/utils/theme/custom_themes/text_field_theme.dart';
import 'package:turn_page_transition/turn_page_transition.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.white,
    appBarTheme: TAppBarTheme.lightAppBar,
    inputDecorationTheme: TTextFieldTheme.lightInputDecoration,
    textTheme: TTextTheme.lightTextTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: AppColors.white),
  );
}
