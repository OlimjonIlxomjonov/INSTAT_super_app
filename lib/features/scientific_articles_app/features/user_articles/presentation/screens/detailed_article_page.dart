import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/params/article_params/article_params.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/utils/constants/assets/app_animations.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/article_process/article_process_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/article_process/article_process_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/review_files/review_files_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/file_opening_overlay/file_opening_overlay_wg.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';
import 'package:my_template/core/utils/widgets/edu_categories/edu_categories_wg.dart';
import 'package:my_template/features/scientific_articles_app/articles_widgets/detailed_article_body_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_authors/review_author_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_detail/review_detail_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/review_authors/review_authors_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/review_authors/review_authors_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/review_detail/review_detail_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/review_detail/review_detail_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/articles_status_check_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/screens/add_article/add_article_page.dart';

import '../../../home/domain/entity/article_process/article_process_entity.dart';
import '../../../home/presentation/widgets/last_actions/last_actions_item_wg.dart';

class DetailedArticlePage extends StatefulWidget {
  final int reviewId;
  final ArticleStatus status;

  const DetailedArticlePage({
    super.key,
    required this.reviewId,
    required this.status,
  });

  @override
  State<DetailedArticlePage> createState() => _DetailedArticlePageState();
}

class _DetailedArticlePageState extends State<DetailedArticlePage> {
  int selectedCategory = 0;

  final ValueNotifier<bool> _isOpeningFile = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    context.read<ReviewDetailBloc>().add(
      ReviewDetailEvent(reviewId: widget.reviewId),
    );
    context.read<ReviewAuthorsBloc>().add(
      ReviewAuthorsEvent(reviewId: widget.reviewId),
    );
    context.read<ArticleProcessBloc>().add(
      ArticleProcessEvent(articleId: widget.reviewId),
    );
    context.read<ReviewFilesBloc>().add(
      ReviewFilesEvent(
        params: ArticleProcessParams(articleId: widget.reviewId),
      ),
    );
  }

  @override
  void dispose() {
    _isOpeningFile.dispose();
    super.dispose();
  }

  void _openEditDraft(BuildContext context) {
    FamilyNavigation.familyPush(
      context,
      AddArticlePage(editReviewId: widget.reviewId),
      showHandle: false,
    );
  }

  Future<void> _openFile(String? url) async {
    if (url == null || url.isEmpty) {
      if (mounted) {
        errorFlushBar(context, AppLocalizations.of(context)!.fileUrlNotFound);
      }
      return;
    }

    if (_isOpeningFile.value) return;
    _isOpeningFile.value = true;

    try {
      final tempDir = await getTemporaryDirectory();
      // Extract the file name from the URL path
      final fileName = Uri.parse(url).pathSegments.last;
      final savePath = '${tempDir.path}/$fileName';

      final dio = Dio();
      await dio.download(url, savePath);

      final result = await OpenFilex.open(savePath);
      if (result.type != ResultType.done && mounted) {
        errorFlushBar(
          context,
          AppLocalizations.of(context)!.fileOpenError(result.message),
        );
      }
    } catch (e) {
      if (mounted) {
        errorFlushBar(context, AppLocalizations.of(context)!.fileDownloadError);
      }
    } finally {
      if (mounted) _isOpeningFile.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final categoryName = [
      localization.wizardHeaderArticleInfo,
      localization.processTab,
    ];

    final reviewDetailState = context.watch<ReviewDetailBloc>().state;
    final effectiveStatus = reviewDetailState is ReviewDetailLoaded
        ? reviewDetailState.response.articleStatus
        : widget.status;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                toolbarHeight: 70,
                titleSpacing: 0,
                automaticallyImplyLeading: false,
                title: SheetDragAreaWg(
                  child: CustomAppBarWg(
                    myTitle: localization.articleDetailsTitle,
                  ),
                ),
              ),

              /// CATEGORIES tab row
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(right: 20, bottom: 20),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(2, (index) {
                      return EduCategoriesWg(
                        categoryIcon: FlutterRemix.layout_grid_line,
                        categoryName: categoryName[index],
                        isSelected: selectedCategory == index,
                        onTap: () {
                          setState(() => selectedCategory = index);
                        },
                      );
                    }),
                  ),
                ),
              ),

              //! Maqola ma'lumotlari
              if (selectedCategory == 0)
                BlocBuilder<ReviewDetailBloc, ReviewDetailState>(
                  builder: (context, detailState) {
                    return BlocBuilder<ReviewAuthorsBloc, ReviewAuthorsState>(
                      builder: (context, authorsState) {
                        final isLoading =
                            detailState is ReviewDetailLoading ||
                            authorsState is ReviewAuthorsLoading ||
                            detailState is ReviewDetailInitial ||
                            authorsState is ReviewAuthorsInitial;

                        final isError =
                            detailState is ReviewDetailError ||
                            authorsState is ReviewAuthorsError;

                        if (isError) {
                          return SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 48,
                                ),
                                child: Text(localization.detailsLoadError),
                              ),
                            ),
                          );
                        }

                        // Use real data when loaded, skeleton data when loading
                        final ReviewDetailEntity? detail =
                            detailState is ReviewDetailLoaded
                            ? detailState.response
                            : null;

                        final List<ReviewAuthorEntity> authors =
                            authorsState is ReviewAuthorsLoaded
                            ? authorsState.response
                            : _skeletonAuthors;

                        return Skeletonizer.sliver(
                          enabled: isLoading,
                          child: SliverPadding(
                            padding: AppPadding.horizontal20x(),
                            sliver: SliverToBoxAdapter(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Article date & status row
                                  Row(
                                    children: [
                                      Icon(
                                        IconlyLight.calendar,
                                        color: AppColors.greyScale.grey600,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        detail != null &&
                                                detail.createdAt != null
                                            ? '${detail.createdAt!.day.toString().padLeft(2, '0')}.'
                                                  '${detail.createdAt!.month.toString().padLeft(2, '0')}.'
                                                  '${detail.createdAt!.year}'
                                            : '00.00.0000',
                                        style: AppTextStyles.source.regular(
                                          fontSize: 12,
                                          color: AppColors.greyScale.grey600,
                                        ),
                                      ),
                                      const Spacer(),
                                      ArticlesStatusCheckWg(
                                        status: effectiveStatus,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  DetailedArticleBodyWg(
                                    detail: detail,
                                    authors: isLoading ? authors : authors,
                                    onFileOpen: (url) => _openFile(url),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              //! Jarayon
              else ...[
                BlocBuilder<ArticleProcessBloc, ArticleProcessState>(
                  builder: (context, state) {
                    if (state is ArticleProcessLoaded) {
                      final grouped = <int, List<ArticleProcessEntity>>{};

                      for (final item in state.entity) {
                        grouped.putIfAbsent(item.cycle, () => []).add(item);
                      }

                      final cycles = grouped.entries.toList()
                        ..sort((a, b) => a.key.compareTo(b.key));

                      return SliverMainAxisGroup(
                        slivers: cycles.expand((entry) {
                          final cycle = entry.key;
                          final items = entry.value;

                          return [
                            SliverPadding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                bottom: 20,
                                top: 20,
                              ),
                              sliver: SliverToBoxAdapter(
                                child: Text(
                                  localization.cycleLabel(cycle),
                                  style: CustomTextStyles.h2,
                                ),
                              ),
                            ),

                            SliverToBoxAdapter(
                              child: Container(
                                margin: AppPadding.horizontal20x(),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.greyScale.grey200,
                                  ),
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
                              ),
                            ),
                          ];
                        }).toList(),
                      );
                    }
                    if (state is ArticleProcessError) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 48),
                            child: AppEmptyState(
                              animationAsset: AppAnimations.errorState,
                              title: localization.detailsLoadError,
                            ),
                          ),
                        ),
                      );
                    }
                    return SliverToBoxAdapter(child: SizedBox.shrink());
                  },
                ),
              ],
            ],
          ),

          /// File-opening overlay — covers entire screen while downloading
          ValueListenableBuilder<bool>(
            valueListenable: _isOpeningFile,
            builder: (context, isOpening, _) {
              if (!isOpening) return const SizedBox.shrink();
              return const FileOpeningOverlayWg();
            },
          ),
        ],
      ),
      bottomNavigationBar: effectiveStatus == ArticleStatus.draft
          ? CustomBottomNavContainerWg(
              leadingIcon: IconlyLight.edit,
              buttonText: localization.edit,
              onTap: () => _openEditDraft(context),
            )
          : null,
    );
  }
}

final List<ReviewAuthorEntity> _skeletonAuthors = List.generate(
  2,
  (i) => ReviewAuthorEntity(
    id: i,
    firstName: 'Ism Familiya',
    lastName: '',
    review: 0,
    address: '',
    organization: 'Tashkilot nomi',
    email: '',
    phoneNumber: '998 90 000 00 00',
    orcidCode: '',
  ),
);
