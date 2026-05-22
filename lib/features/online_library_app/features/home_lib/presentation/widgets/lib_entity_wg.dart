import 'dart:ui';

import 'package:my_template/core/utils/app_utils.dart';

class UserLibInfo {
  final String cardName;
  final String iconPath;
  final List<Color> backColors;

  UserLibInfo({
    required this.cardName,
    required this.iconPath,
    required this.backColors,
  });
}

final cardInfo = [
  UserLibInfo(
    cardName: 'Xaridlar',
    iconPath: AppVectors.cartBrief,
    backColors: [AppColors.linearLightGreen, AppColors.linearDarkGreen],
  ),
  UserLibInfo(
    cardName: "O'qilmoqda",
    iconPath: AppVectors.bookOpenBrief,
    backColors: [AppColors.linearLightBlue, AppColors.linearDarkBlue],
  ),
  UserLibInfo(
    cardName: 'Olingan kitoblar',
    iconPath: AppVectors.bookShvBrief,
    backColors: [AppColors.linearLightOrange, AppColors.linearDarkOrange],
  ),
  UserLibInfo(
    cardName: 'Tugalangan',
    iconPath: AppVectors.trophyBrief,
    backColors: [AppColors.linearLightPurple, AppColors.linearDarkPurple],
  ),
];
