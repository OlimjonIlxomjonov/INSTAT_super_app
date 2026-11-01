import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/refresh_indicator/custom_refresh_insidcator.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/common/ui_states/section_error_wg.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/appear/appear_wg.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/articles/presentation/screens/article_detail_page.dart';
import 'package:my_template/features/scientific_articles_app/features/articles/presentation/widgets/article_brief_card_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_brief/article_brief_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_by_keyword/articles_by_keyword_cubit.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ArticlesByKeywordPage extends StatelessWidget {
  final String keyword;

  const ArticlesByKeywordPage({super.key, required this.keyword});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ArticlesByKeywordCubit>()..load(keyword),
      child: _ArticlesByKeywordView(keyword: keyword),
    );
  }
}

class _ArticlesByKeywordView extends StatelessWidget {
  final String keyword;

  const _ArticlesByKeywordView({required this.keyword});

  bool _onScroll(BuildContext context, ScrollNotification notification) {
    if (notification.metrics.axis == Axis.vertical &&
        notification.metrics.extentAfter < 300) {
      context.read<ArticlesByKeywordCubit>().loadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      body: CustomRefreshIndicator(
        onRefresh: () => context.read<ArticlesByKeywordCubit>().refresh(),
        child: BlocBuilder<ArticlesByKeywordCubit, ArticlesByKeywordState>(
          builder: (context, state) {
            return NotificationListener<ScrollNotification>(
              onNotification: (notification) =>
                  _onScroll(context, notification),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: SheetDragAreaWg(
                      child: CustomAppBarWg(
                        myTitle: l.keywordArticlesTitle,
                        isFamily: true,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                    sliver: SliverToBoxAdapter(
                      child: _KeywordHeader(
                        keyword: keyword,
                        total: state.isLoaded ? state.total : null,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                    sliver: _buildBody(context, state),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ArticlesByKeywordState state) {
    final l = AppLocalizations.of(context)!;

    if (state.error != null) {
      return SliverToBoxAdapter(
        child: SectionErrorWg(
          title: state.error!.isEmpty ? null : state.error,
          onRetry: () => context.read<ArticlesByKeywordCubit>().refresh(),
        ),
      );
    }

    if (!state.isLoaded) {
      return Skeletonizer.sliver(
        child: SliverList.builder(
          itemCount: 4,
          itemBuilder: (_, index) => _card(context, _skeletonItem(index)),
        ),
      );
    }

    final items = state.items!;
    if (items.isEmpty) {
      return SliverToBoxAdapter(
        child: AppEmptyState(
          title: l.noKeywordArticlesTitle,
          subtitle: l.noKeywordArticlesSubtitle,
        ),
      );
    }

    return SliverMainAxisGroup(
      slivers: [
        AppearScope(
          child: SliverList.builder(
            itemCount: items.length,
            itemBuilder: (_, index) => AppearItem(
              key: ValueKey(items[index].id),
              id: items[index].id,
              child: _card(context, items[index]),
            ),
          ),
        ),
        if (state.isLoadingMore)
          Skeletonizer.sliver(
            child: SliverList.builder(
              itemCount: 2,
              itemBuilder: (_, index) => _card(context, _skeletonItem(index)),
            ),
          ),
      ],
    );
  }

  Widget _card(BuildContext context, ArticleBriefEntity item) {
    return ArticleBriefCardWg(
      item: item,
      onTap: () => openMiniAppSheetFamily(
        context,
        child: ArticleDetailPage(reviewId: item.id),
        showHandler: false,
      ),
    );
  }

  ArticleBriefEntity _skeletonItem(int index) => ArticleBriefEntity(
    id: index,
    title: 'Maqola sarlavhasi bu yerda ikki qatorda turadi',
    createdAt: DateTime(2026),
  );
}

class _KeywordHeader extends StatelessWidget {
  final String keyword;
  final int? total;

  const _KeywordHeader({required this.keyword, required this.total});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Row(
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.iconBlueBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  FlutterRemix.hashtag,
                  size: 16,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    keyword,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.source.semiBold(
                      fontSize: 15,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        AnimatedOpacity(
          opacity: total == null ? 0 : 1,
          duration: const Duration(milliseconds: 250),
          child: Text(
            l.articlesFoundCount(total ?? 0),
            style: AppTextStyles.source.regular(
              fontSize: 13,
              color: AppColors.greyScale.grey600,
            ),
          ),
        ),
      ],
    );
  }
}
