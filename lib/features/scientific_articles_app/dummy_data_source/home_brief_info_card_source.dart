import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/scientific_articles_app/dummy_models/home_brief_info_card_model.dart';

final briefInfoCardList = [
  HomeBriefInfoCardModel(
    iconColor: AppColors.iconBlue,
    iconBackgroundColor: AppColors.iconBlueBackground,
    icon: IconlyLight.document,
    title: 'Barcha maqolalar',
    value: '12',
  ),
  HomeBriefInfoCardModel(
    iconColor: AppColors.orange500,
    iconBackgroundColor: AppColors.orange50,
    icon: IconlyLight.chart,
    title: 'Tekshiruvda',
    value: '3',
  ),
  HomeBriefInfoCardModel(
    iconColor: AppColors.iconRed,
    iconBackgroundColor: AppColors.iconRedBackground,
    icon: IconlyLight.edit_square,
    title: 'Tuzatish kerak',
    value: '2',
  ),
  HomeBriefInfoCardModel(
    iconColor: AppColors.iconGreen,
    iconBackgroundColor: AppColors.iconGreenBackground,
    icon: Icons.check_circle_outline,
    title: 'Chop etilgan',
    value: '8',
  ),
];
