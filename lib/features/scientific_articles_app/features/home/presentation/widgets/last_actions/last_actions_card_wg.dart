import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_process/article_process_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/last_actions/last_actions_item_wg.dart';

class LastActionsCard extends StatelessWidget {
  final List<ArticleProcessEntity> items;
  final int? limit;

  const LastActionsCard({super.key, required this.items, this.limit});

  @override
  Widget build(BuildContext context) {
    final displayItems = (limit != null && limit! < items.length)
        ? items.sublist(0, limit)
        : items;

    return Container(
      margin: AppPadding.horizontal20x(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyScale.grey200),
      ),
      child: Column(
        children: List.generate(
          displayItems.length,
          (index) => LastActionItem(
            item: items[index],
            isLast: index == items.length - 1,
          ),
        ),
      ),
    );
  }
}
