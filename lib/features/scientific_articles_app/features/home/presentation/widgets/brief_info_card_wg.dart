import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/scientific_articles_app/dummy_models/home_brief_info_card_model.dart';

class BriefInfoCardWg extends StatelessWidget {
  final HomeBriefInfoCardModel item;
  final String value;

  const BriefInfoCardWg({super.key, required this.item, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyScale.grey200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: item.iconBackgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(item.icon, color: item.iconColor),
          ),
          Text(
            item.title,
            style: AppTextStyles.source.medium(
              fontSize: 14,
              color: AppColors.greyScale.grey600,
            ),
          ),
          Text(value, style: AppTextStyles.source.semiBold(fontSize: 24)),
        ],
      ),
    );
  }
}
