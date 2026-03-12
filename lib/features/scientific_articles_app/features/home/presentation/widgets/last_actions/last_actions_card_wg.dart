import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/scientific_articles_app/dummy_models/last_actions_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/last_actions/last_actions_item_wg.dart';

class LastActionsCard extends StatelessWidget {
  final List<LastActionModel> items;

  const LastActionsCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppPadding.horizontal20x(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyScale.grey200),
      ),
      child: Column(
        children: List.generate(
          items.length,
          (index) => LastActionItem(
            item: items[index],
            isLast: index == items.length - 1,
          ),
        ),
      ),
    );
  }
}
