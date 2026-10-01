import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/common/ui_states/section_error_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/features/scientific_articles_app/features/articles/presentation/screens/article_detail_page.dart';
import 'package:my_template/features/scientific_articles_app/features/articles/presentation/widgets/article_brief_card_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_brief/article_brief_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/article_related/article_related_cubit.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ArticleRelatedTabWg extends StatelessWidget {
  final String emptyTitle;
  final String emptySubtitle;
  final VoidCallback onRetry;

  const ArticleRelatedTabWg({
    super.key,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleRelatedCubit, ArticleRelatedState>(
      builder: (context, state) {
        final section = state.current;

        if (section.error != null) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SectionErrorWg(
              title: section.error!.isEmpty ? null : section.error,
              onRetry: onRetry,
            ),
          );
        }

        if (section.isLoaded && section.items!.isEmpty) {
          return AppEmptyState(title: emptyTitle, subtitle: emptySubtitle);
        }

        final items = section.items ?? _skeletonItems;

        return Skeletonizer(
          enabled: !section.isLoaded,
          child: Column(
            children: [
              for (final item in items)
                ArticleBriefCardWg(
                  item: item,
                  onTap: () => openMiniAppSheetFamily(
                    context,
                    child: ArticleDetailPage(reviewId: item.id),
                    showHandler: false,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

//! Skeleton uchun
final _skeletonItems = List.generate(
  3,
  (index) => ArticleBriefEntity(
    id: index,
    title: 'Maqola sarlavhasi bu yerda ikki qatorda turadi',
    createdAt: DateTime(2026),
  ),
);
