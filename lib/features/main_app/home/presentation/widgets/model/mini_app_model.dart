import 'package:flutter/cupertino.dart';

class MiniAppModel {
  final String mainImage;
  final String backgroundImage;
  final String title;
  final List<Color> colors;
  final void Function(BuildContext context) onTap;

  const MiniAppModel({
    required this.mainImage,
    required this.backgroundImage,
    required this.title,
    required this.onTap,
    required this.colors,
  });
}
