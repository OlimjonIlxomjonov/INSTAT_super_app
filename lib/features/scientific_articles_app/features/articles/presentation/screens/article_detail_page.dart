import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/common/refresh_indicator/custom_refresh_insidcator.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/common/ui_states/section_error_wg.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/files/remote_file_opener.dart';
import 'package:my_template/core/utils/localization/localized_text.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/detail_tabs/detail_tabs_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/articles/presentation/widgets/article_related_tab_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_quote/article_quote_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_authors/review_author_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_detail/review_detail_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/article_quote/article_quote_cubit.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/article_related/article_related_cubit.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/review_detail/review_detail_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/review_detail/review_detail_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ArticleDetailPage extends StatelessWidget {
  final int reviewId;

  const ArticleDetailPage({super.key, required this.reviewId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              sl<ReviewDetailBloc>()
                ..add(ReviewDetailEvent(reviewId: reviewId)),
        ),
        BlocProvider(
          create: (_) =>
              sl<ArticleRelatedCubit>()
                ..selectTab(ArticleRelatedTab.byAuthor, reviewId),
        ),
        BlocProvider(create: (_) => sl<ArticleQuoteCubit>()),
      ],
      child: _ArticleDetailView(reviewId: reviewId),
    );
  }
}

class _ArticleDetailView extends StatefulWidget {
  final int reviewId;

  const _ArticleDetailView({required this.reviewId});

  @override
  State<_ArticleDetailView> createState() => _ArticleDetailViewState();
}

class _ArticleDetailViewState extends State<_ArticleDetailView> {
  int? _quotesCountOverride;
  bool _isDownloading = false;

  void _refreshAll() {
    context.read<ReviewDetailBloc>().add(
      ReviewDetailEvent(reviewId: widget.reviewId),
    );
    context.read<ArticleRelatedCubit>().refreshAll(widget.reviewId);
  }

  void _openQuote() {
    final l = AppLocalizations.of(context)!;

    context.read<ArticleQuoteCubit>().create(
      widget.reviewId,
      onSuccess: (quote) {
        if (!mounted) return;
        setState(() => _quotesCountOverride = quote.quotesCount);
        _showQuoteSheet(quote);
      },
      onError: (message) {
        if (!mounted) return;
        errorFlushBar(context, message ?? l.sectionLoadError);
      },
    );
  }

  void _showQuoteSheet(ArticleQuoteEntity quote) {
    final l = AppLocalizations.of(context)!;

    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l.quoteTitle,
                      style: AppTextStyles.source.semiBold(fontSize: 18),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.greyScale.grey50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.greyScale.grey200),
                ),
                child: SelectableText(
                  quote.text,
                  style: AppTextStyles.source.regular(fontSize: 14),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: quote.text));
                    if (!sheetContext.mounted) return;
                    Navigator.of(sheetContext).pop();
                    if (mounted) successFlushBar(context, l.copiedToClipboard);
                  },
                  icon: const Icon(FlutterRemix.file_copy_line, size: 20),
                  label: Text(l.copyText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      body: CustomRefreshIndicator(
        onRefresh: () async => _refreshAll(),
        child: BlocBuilder<ReviewDetailBloc, ReviewDetailState>(
          builder: (context, state) {
            final detail = state is ReviewDetailLoaded ? state.response : null;

            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: SheetDragAreaWg(
                    child: CustomAppBarWg(
                      myTitle: l.articleDetailsTitle,
                      isFamily: true,
                      customActions: detail == null
                          ? null
                          : _buildActions(detail),
                    ),
                  ),
                ),

                if (state is ReviewDetailError)
                  SliverToBoxAdapter(
                    child: state.notFound
                        ? AppEmptyState(
                            title: l.articleNotFoundTitle,
                            subtitle: l.articleNotFoundSubtitle,
                          )
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                            child: SectionErrorWg(
                              title: state.message,
                              onRetry: () =>
                                  context.read<ReviewDetailBloc>().add(
                                    ReviewDetailEvent(
                                      reviewId: widget.reviewId,
                                    ),
                                  ),
                            ),
                          ),
                  )
                else ...[
                  //! Maqola
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: Skeletonizer(
                        enabled: detail == null,
                        child: _buildHeader(detail ?? _skeletonDetail),
                      ),
                    ),
                  ),

                  //! Tablar
                  SliverToBoxAdapter(
                    child:
                        BlocBuilder<ArticleRelatedCubit, ArticleRelatedState>(
                          builder: (context, related) => DetailTabsWg(
                            padding: const EdgeInsets.fromLTRB(10, 0, 20, 16),
                            tabs: [
                              DetailTabItem(
                                label: l.authorOtherArticles,
                                icon: FlutterRemix.user_3_line,
                              ),
                              DetailTabItem(
                                label: l.similarArticles,
                                icon: FlutterRemix.file_list_2_line,
                              ),
                            ],
                            selectedIndex:
                                related.tab == ArticleRelatedTab.byAuthor
                                ? 0
                                : 1,
                            onChanged: (index) =>
                                context.read<ArticleRelatedCubit>().selectTab(
                                  index == 0
                                      ? ArticleRelatedTab.byAuthor
                                      : ArticleRelatedTab.bySection,
                                  widget.reviewId,
                                ),
                          ),
                        ),
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                    sliver: SliverToBoxAdapter(
                      child:
                          BlocBuilder<ArticleRelatedCubit, ArticleRelatedState>(
                            builder: (context, related) {
                              final isAuthorTab =
                                  related.tab == ArticleRelatedTab.byAuthor;
                              return ArticleRelatedTabWg(
                                emptyTitle: isAuthorTab
                                    ? l.noAuthorArticlesTitle
                                    : l.noSimilarArticlesTitle,
                                emptySubtitle: isAuthorTab
                                    ? l.noAuthorArticlesSubtitle
                                    : l.noSimilarArticlesSubtitle,
                                onRetry: () => context
                                    .read<ArticleRelatedCubit>()
                                    .reload(widget.reviewId),
                              );
                            },
                          ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _openArticleFile(ReviewDetailEntity detail) async {
    if (_isDownloading) return;
    setState(() => _isDownloading = true);

    await openRemoteFile(context, url: detail.mainFile);

    if (mounted) setState(() => _isDownloading = false);
  }

  //! App bar amallari
  List<Widget> _buildActions(ReviewDetailEntity detail) {
    final l = AppLocalizations.of(context)!;
    final isQuoting = context.watch<ArticleQuoteCubit>().state;
    final hasFile = detail.mainFile != null && detail.mainFile!.isNotEmpty;

    return [
      if (hasFile)
        IconButton(
          tooltip: l.openArticleFile,
          onPressed: _isDownloading ? null : () => _openArticleFile(detail),
          icon: _isDownloading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  FlutterRemix.article_line,
                  size: 22,
                  color: AppColors.greyScale.grey800,
                ),
        ),
      IconButton(
        tooltip: l.quoteArticle,
        onPressed: isQuoting ? null : _openQuote,
        icon: isQuoting
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                FlutterRemix.double_quotes_l,
                size: 22,
                color: AppColors.greyScale.grey800,
              ),
      ),
      const SizedBox(width: 4),
    ];
  }

  Widget _buildHeader(ReviewDetailEntity detail) {
    final l = AppLocalizations.of(context)!;
    final quotesCount = _quotesCountOverride ?? detail.quotesCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(detail.title, style: AppTextStyles.source.semiBold(fontSize: 18)),
        const SizedBox(height: 10),

        //! Hisoblagichlar
        Row(
          children: [
            _Counter(
              icon: FlutterRemix.double_quotes_l,
              label: l.quotesLabel,
              value: quotesCount,
            ),
            const SizedBox(width: 20),
            _Counter(
              icon: FlutterRemix.download_2_line,
              label: l.downloadsLabel,
              value: detail.downloadCount,
            ),
          ],
        ),
        const SizedBox(height: 20),

        _ArticleBody(detail: detail),
      ],
    );
  }
}

class _ArticleBody extends StatelessWidget {
  final ReviewDetailEntity detail;

  const _ArticleBody({required this.detail});

  String _annotation(String localeCode) => localizedText(
    localeCode: localeCode,
    fallback: detail.annotationUz ?? '',
    uz: detail.annotationUz,
    ru: detail.annotationRu,
    en: detail.annotationEn,
  );

  List<String> get _keywords {
    final raw = detail.keywords.trim();
    if (raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) return decoded.map((e) => e.toString()).toList();
    } catch (_) {}
    return raw
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll('"', '')
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final localeCode = Localizations.localeOf(context).languageCode;
    final annotation = _annotation(localeCode);
    final keywords = _keywords;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //! Mualliflar
        if (detail.reviewAuthors.isNotEmpty) ...[
          Text(l.authors, style: AppTextStyles.source.semiBold(fontSize: 16)),
          const SizedBox(height: 10),
          for (final author in detail.reviewAuthors)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.greyScale.grey200),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.iconBlueBackground,
                      ),
                      child: const Icon(
                        IconlyLight.profile,
                        size: 18,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${author.firstName} ${author.lastName}'.trim(),
                            style: AppTextStyles.source.medium(fontSize: 14),
                          ),
                          if (_subtitle(author).isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              _subtitle(author),
                              style: AppTextStyles.source.regular(
                                fontSize: 12,
                                color: AppColors.greyScale.grey600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 10),
        ],

        //! Annotatsiya
        if (annotation.trim().isNotEmpty) ...[
          Text(
            l.annotation,
            style: AppTextStyles.source.semiBold(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            annotation,
            style: AppTextStyles.source.regular(
              fontSize: 14,
              color: AppColors.greyScale.grey700,
            ),
          ),
          const SizedBox(height: 16),
        ],

        //! Kalit so'zlar
        if (keywords.isNotEmpty) ...[
          Text(l.keywords, style: AppTextStyles.source.semiBold(fontSize: 16)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final keyword in keywords)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.greyScale.grey100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    keyword,
                    style: AppTextStyles.source.regular(fontSize: 12),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }

  String _subtitle(ReviewAuthorEntity author) => [
    author.academicDegree?.name,
    author.organization,
  ].whereType<String>().where((e) => e.trim().isNotEmpty).join(' · ');
}

class _Counter extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;

  const _Counter({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.greyScale.grey500),
        const SizedBox(width: 6),
        Text(
          '$label: $value',
          style: AppTextStyles.source.regular(
            fontSize: 13,
            color: AppColors.greyScale.grey600,
          ),
        ),
      ],
    );
  }
}

//! Skeleton uchun
final _skeletonDetail = ReviewDetailEntity(
  id: 0,
  title: 'Maqola sarlavhasi bu yerda ikki qatorda turishi mumkin',
  articleType: 0,
  journalSection: 0,
  udkCode: '',
  status: '',
  language: '',
  userId: 0,
  keywords: '',
);
