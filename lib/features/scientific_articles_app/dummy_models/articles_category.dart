import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/app_utils.dart';

const List categories = [
  'Barchasi',
  'Chop etilgan',
  'Nashrga tayyor',
  'Tekshiruda',
  'Bekor qilingan',
  'Qoralamalar',
];

List<IconData> categoriesIcon = [
  IconlyLight.discovery,
  IconlyLight.edit,
  IconlyLight.tick_square,
  IconlyLight.danger,
  IconlyLight.info_circle,
  IconlyLight.paper,
];

List<Color> categoryColors = [
  AppColors.primaryColor,
  AppColors.greenDoneTaskCard,
  AppColors.yellow500,
  AppColors.orange500,
  AppColors.red,
  AppColors.greyScale.grey900,
];

const List articleStatus = [
  'all',
  'published',
  'accepted',
  'in_review',
  'rejected',
  'draft',
];
