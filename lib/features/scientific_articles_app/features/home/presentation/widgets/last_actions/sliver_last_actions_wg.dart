import 'package:flutter/material.dart';
import 'package:my_template/features/scientific_articles_app/dummy_models/last_actions_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_process/article_process_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/last_actions/last_actions_card_wg.dart';

class SliverLastActionsWg extends StatelessWidget {
  final List<ArticleProcessEntity> items;

  const SliverLastActionsWg({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: .only(bottom: 20),
      sliver: SliverToBoxAdapter(child: LastActionsCard(items: items)),
    );
  }
}
