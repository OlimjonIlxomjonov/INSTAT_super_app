import 'dart:ui';

import 'package:my_template/core/l10n/app_localizations.dart';
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

List<UserLibInfo> getCardInfo(AppLocalizations localization) => [
  UserLibInfo(
    cardName: localization.purchases,
    iconPath: AppVectors.cartBrief,
    backColors: [AppColors.linearLightGreen, AppColors.linearDarkGreen],
  ),
  UserLibInfo(
    cardName: localization.currentlyReading,
    iconPath: AppVectors.bookOpenBrief,
    backColors: [AppColors.linearLightBlue, AppColors.linearDarkBlue],
  ),
  UserLibInfo(
    cardName: localization.booksObtained,
    iconPath: AppVectors.bookShvBrief,
    backColors: [AppColors.linearLightOrange, AppColors.linearDarkOrange],
  ),
  UserLibInfo(
    cardName: localization.finished,
    iconPath: AppVectors.trophyBrief,
    backColors: [AppColors.linearLightPurple, AppColors.linearDarkPurple],
  ),
];
