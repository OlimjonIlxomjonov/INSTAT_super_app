import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/scientific_articles_app/dummy_models/home_brief_info_card_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/articles_stats/articles_stats_entity.dart';

import 'brief_info_card_wg.dart';

class SliverBriefCardsWg extends StatelessWidget {
  final List<HomeBriefInfoCardModel> items;
  final ArticlesStatsEntity? entity;
  final bool isLoading;

  const SliverBriefCardsWg({
    super.key,
    required this.items,
    required this.entity,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final counts = [
      entity?.all ?? 0,
      entity?.inReview ?? 0,
      entity?.cancelled ?? 0,
      entity?.published ?? 0,
    ];

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
          return Skeletonizer(
            enabled: isLoading,
            child: BriefInfoCardWg(item: item, value: counts[index].toString()),
          );
        },
      ),
    );
  }
}
