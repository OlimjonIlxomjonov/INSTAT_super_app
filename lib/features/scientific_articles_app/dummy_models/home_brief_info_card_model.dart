import 'package:flutter/material.dart';


class HomeBriefInfoCardModel {
  final IconData icon;
  final Color iconColor, iconBackgroundColor;
  final String title, value;

  HomeBriefInfoCardModel({
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.icon,
    required this.title,
    required this.value,
  });
}

