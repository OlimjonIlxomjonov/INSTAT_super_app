import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/common/ui_states/error_page.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_editions/article_editions_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/edition_articles/edition_article_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/edition_articles/edition_articles_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/edition_articles/edition_articles_state.dart';
import 'package:my_template/features/scientific_articles_app/features/magazines/widgets/edition_article_card_wg.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MagazineDetailPage extends StatelessWidget {
  final ArticleEditionsEntity edition;

  const MagazineDetailPage({super.key, required this.edition});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<EditionArticlesBloc>()
            ..add(EditionArticlesEvent(editionId: edition.id)),
      child: _MagazineDetailView(edition: edition),
    );
  }
}

class _MagazineDetailView extends StatelessWidget {
  final ArticleEditionsEntity edition;

  const _MagazineDetailView({required this.edition});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SheetDragAreaWg(
              child: CustomAppBarWg(myTitle: 'Jurnal tavsiloti'),
            ),
          ),

          // Edition header
          SliverPadding(
            padding: AppPadding.horizontal20x(),
            sliver: SliverToBoxAdapter(child: _buildHeader(context)),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Articles section
          BlocBuilder<EditionArticlesBloc, EditionArticlesState>(
            builder: (context, state) {
              if (state is EditionArticlesLoaded) {
                return SliverPadding(
                  padding: AppPadding.horizontal20x(),
                  sliver: SliverMainAxisGroup(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                localization.articles,
                                style: CustomTextStyles.h2,
                              ),
                              Text(
                                '(${state.items.length})',
                                style: AppTextStyles.source.regular(
                                  fontSize: 16,
                                  color: AppColors.greyScale.grey400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (state.items.isEmpty)
                        SliverToBoxAdapter(
                          child: AppEmptyState(
                            title: localization.emptyEditionArticlesTitle,
                            subtitle: localization.emptyEditionArticlesSubtitle,
                            illustrationSize: 120,
                          ),
                        )
                      else
                        SliverList.builder(
                          itemCount: state.items.length,
                          itemBuilder: (_, index) =>
                              EditionArticleCardWg(item: state.items[index]),
                        ),
                    ],
                  ),
                );
              } else if (state is EditionArticlesError) {
                return const SliverToBoxAdapter(child: ErrorPage());
              }

              //! loading state
              return SliverPadding(
                padding: AppPadding.horizontal20x(),
                sliver: Skeletonizer.sliver(
                  child: SliverList.builder(
                    itemCount: 3,
                    itemBuilder: (_, index) => EditionArticleCardWg(
                      item: EditionArticleEntity(
                        id: index,
                        order: index,
                        review: const EditionArticleReviewEntity(
                          id: 0,
                          title: 'Loading article title',
                          status: 'published',
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentGeometry.bottomEnd,
          end: AlignmentGeometry.topEnd,
          colors: [Color(0xffF7F7F7), AppColors.white],
        ),
        color: AppColors.greyNewCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: edition.thumbnail != null && edition.thumbnail!.isNotEmpty
                  ? Image.network(edition.thumbnail!, fit: BoxFit.contain)
                  : Container(
                      color: AppColors.greyScale.grey200,
                      child: Icon(
                        Icons.image,
                        color: AppColors.greyScale.grey400,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Text(edition.title ?? '', style: CustomTextStyles.h2),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(
              context,
            )!.yearIssue(edition.year ?? '', edition.number ?? ''),
            style: AppTextStyles.source.regular(
              fontSize: 14,
              color: AppColors.greyScale.grey600,
            ),
          ),
        ],
      ),
    );
  }
}
