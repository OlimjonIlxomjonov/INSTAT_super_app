import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_process/article_process_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/last_actions/last_actions_card_wg.dart';

import '../../../../../../../core/utils/widgets/app_widgets.dart';
import '../../screens/detailed_last_actions_page.dart';

class SliverLastActionsWg extends StatelessWidget {
  final List<ArticleProcessEntity> items;
  final int? limit;

  const SliverLastActionsWg({super.key, required this.items, this.limit});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return SliverPadding(
      padding: .only(bottom: 20),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            if (limit != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ExtendSectionSeeAllWg(
                  title: localization.recentActions,
                  onTap: () {
                    openMiniAppSheetFamily(
                      showHandler: false,
                      context,
                      child: DetailedLastActionsPage(item: items),
                    );
                  },
                ),
              ),
            LastActionsCard(items: items, limit: limit),
          ],
        ),
      ),
    );
  }
}
