import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/scientific_articles_app/dummy_models/last_actions_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/last_actions/last_actions_status_icon_wg.dart';

class LastActionItem extends StatelessWidget {
  final LastActionModel item;
  final bool isLast;

  const LastActionItem({super.key, required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .all(12),
      decoration: BoxDecoration(
        border: Border(
          bottom: !isLast
              ? BorderSide(color: AppColors.greyScale.grey200)
              : BorderSide.none,
        ),
      ),
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TIMELINE COLUMN
          Column(
            children: [
              LastActionsStatusIconWg(status: item.status),
              Container(
                margin: const .only(top: 5),
                width: 1,
                height: 60,
                color: AppColors.greyScale.grey400,
              ),
            ],
          ),

          /// CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTextStyles.source.medium(fontSize: 16),
                ),

                const SizedBox(height: 4),

                Text(
                  item.description,
                  style: AppTextStyles.source.regular(
                    fontSize: 13,
                    color: AppColors.greyScale.grey600,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  item.date,
                  style: AppTextStyles.source.regular(
                    fontSize: 14,
                    color: AppColors.greyScale.grey600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
