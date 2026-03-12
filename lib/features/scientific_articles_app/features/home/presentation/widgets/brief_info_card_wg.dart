import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/scientific_articles_app/dummy_models/home_brief_info_card_model.dart';

class BriefInfoCardWg extends StatelessWidget {
  final HomeBriefInfoCardModel item;

  const BriefInfoCardWg({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(12),
      decoration: BoxDecoration(
        borderRadius: .circular(16),
        border: .all(color: AppColors.greyScale.grey200),
      ),
      child: Column(
        mainAxisAlignment: .spaceBetween,
        crossAxisAlignment: .start,
        children: [
          /// CARD ICON
          Container(
            padding: .all(10),
            decoration: BoxDecoration(
              color: item.iconBackgroundColor,
              borderRadius: .circular(8),
            ),
            child: Icon(item.icon, color: item.iconColor),
          ),

          /// CARD TITLE
          Text(
            item.title,
            style: AppTextStyles.source.medium(
              fontSize: 14,
              color: AppColors.greyScale.grey600,
            ),
          ),

          /// CARD VALUE
          Text(item.value, style: AppTextStyles.source.semiBold(fontSize: 24)),
        ],
      ),
    );
  }
}
