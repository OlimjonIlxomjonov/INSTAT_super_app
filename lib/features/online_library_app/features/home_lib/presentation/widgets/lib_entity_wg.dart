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
    cardName: 'Barcha kitoblarim',
    iconPath: AppVectors.cartBrief,
    backColors: [AppColors.linearLightGreen, AppColors.linearDarkGreen],
  ),
  UserLibInfo(
    cardName: 'Saqlangan',
    iconPath: AppVectors.bookOpenBrief,
    backColors: [AppColors.linearLightBlue, AppColors.linearDarkBlue],
  ),
  UserLibInfo(
    cardName: 'Qarzga olingan',
    iconPath: AppVectors.bookShvBrief,
    backColors: [AppColors.linearLightOrange, AppColors.linearDarkOrange],
  ),
  UserLibInfo(
    cardName: 'Faol qarzga olingan',
    iconPath: AppVectors.trophyBrief,
    backColors: [AppColors.linearLightPurple, AppColors.linearDarkPurple],
  ),
];
