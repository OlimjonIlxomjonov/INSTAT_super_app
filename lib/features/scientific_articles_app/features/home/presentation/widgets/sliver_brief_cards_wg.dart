import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/scientific_articles_app/dummy_models/home_brief_info_card_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/brief_info_card_wg.dart';

class SliverBriefCardsWg extends StatelessWidget {
  final List<HomeBriefInfoCardModel> items;

  const SliverBriefCardsWg({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: AppPadding.hAndV20x20(),
      sliver: SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.1,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return BriefInfoCardWg(item: item);
        },
      ),
    );
  }
}
