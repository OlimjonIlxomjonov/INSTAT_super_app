import 'package:flutter/material.dart';

import '../../app_utils.dart';
import '../../constants/custom_text_styles/custom_text_styles.dart';

class AnnotationLanguageWg extends StatefulWidget {
  final List<bool> isSelected;
  final void Function(int index)? onChanged;

  const AnnotationLanguageWg({
    super.key,
    required this.isSelected,
    this.onChanged,
  });

  @override
  State<AnnotationLanguageWg> createState() => _AnnotationLanguageWgState();
}

class _AnnotationLanguageWgState extends State<AnnotationLanguageWg> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(5),
      decoration: BoxDecoration(
        color: AppColors.greyScale.grey50,
        borderRadius: .circular(10),
      ),
      child: ToggleButtons(
        color: AppColors.greyScale.grey400,
        borderRadius: .circular(6),
        isSelected: widget.isSelected,
        onPressed: widget.onChanged,
        renderBorder: false,
        fillColor: AppColors.primaryColor,
        selectedColor: AppColors.white,
        children: [
          Text('UZ', style: CustomTextStyles.h3half),
          Text('EN', style: CustomTextStyles.h3half),
          Text('RU', style: CustomTextStyles.h3half),
        ],
      ),
    );
  }
}
