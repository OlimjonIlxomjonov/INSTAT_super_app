import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/scientific_articles_app/dummy_models/home_brief_info_card_model.dart';

//! ILMIY MAQOLA
List<HomeBriefInfoCardModel> getBriefInfoCardList(
  AppLocalizations localization,
) => [
  HomeBriefInfoCardModel(
    iconColor: AppColors.iconBlue,
    iconBackgroundColor: AppColors.iconBlueBackground,
    icon: IconlyLight.document,
    title: localization.allArticles,
    value: '12',
  ),
  HomeBriefInfoCardModel(
    iconColor: AppColors.orange500,
    iconBackgroundColor: AppColors.orange50,
    icon: IconlyLight.chart,
    title: localization.underReview,
    value: '3',
  ),
  HomeBriefInfoCardModel(
    iconColor: AppColors.iconRed,
    iconBackgroundColor: AppColors.iconRedBackground,
    icon: IconlyLight.edit_square,
    title: localization.needsCorrection,
    value: '2',
  ),
  HomeBriefInfoCardModel(
    iconColor: AppColors.iconGreen,
    iconBackgroundColor: AppColors.iconGreenBackground,
    icon: Icons.check_circle_outline,
    title: localization.published,
    value: '8',
  ),
];

//! MICRO MALUMOTLAR
List<HomeBriefInfoCardModel> getMicroDataBrief(
  AppLocalizations localization,
) => [
  HomeBriefInfoCardModel(
    iconColor: AppColors.iconBlue,
    iconBackgroundColor: AppColors.iconBlueBackground,
    icon: IconlyLight.document,
    title: localization.allRequestsBrief,
    value: '12',
  ),
  HomeBriefInfoCardModel(
    iconColor: AppColors.orange500,
    iconBackgroundColor: AppColors.orange50,
    icon: IconlyLight.graph,
    title: localization.statusInProgress,
    value: '3',
  ),
  HomeBriefInfoCardModel(
    iconColor: AppColors.iconRed,
    iconBackgroundColor: AppColors.iconRedBackground,
    icon: Icons.cancel_outlined,
    title: localization.cancelledBrief,
    value: '2',
  ),
  HomeBriefInfoCardModel(
    iconColor: AppColors.iconGreen,
    iconBackgroundColor: AppColors.iconGreenBackground,
    icon: Icons.check_circle_outline,
    title: localization.statusConfirmed,
    value: '8',
  ),
];
