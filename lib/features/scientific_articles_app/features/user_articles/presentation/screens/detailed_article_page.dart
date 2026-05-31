import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:my_template/core/common/flush_bar/error_flush_bar.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/general_widgets/file_opening_overlay/file_opening_overlay_wg.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';
import 'package:my_template/core/utils/widgets/edu_categories/edu_categories_wg.dart';
import 'package:my_template/features/scientific_articles_app/articles_widgets/detailed_article_body_wg.dart';
import 'package:my_template/features/scientific_articles_app/dummy_data_source/last_actions_source.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_authors/review_author_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_detail/review_detail_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/review_authors/review_authors_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/review_authors/review_authors_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/review_detail/review_detail_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/review_detail/review_detail_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/articles_status_check_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/last_actions/sliver_last_actions_wg.dart';

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
    context
        .read<ReviewDetailBloc>()
        .add(ReviewDetailEvent(reviewId: widget.reviewId));
    context
        .read<ReviewAuthorsBloc>()
        .add(ReviewAuthorsEvent(reviewId: widget.reviewId));
  }

  @override
  void dispose() {
    _isOpeningFile.dispose();
    super.dispose();
  }

  Future<void> _openFile(String? url) async {
    if (url == null || url.isEmpty) {
      if (mounted) errorFlushBar(context, 'Fayl manzili topilmadi');
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
          'Faylni ochishda xatolik yuz berdi. ${result.message}',
        );
      }
    } catch (e) {
      if (mounted) {
        errorFlushBar(context, 'Faylni yuklab olishda xatolik yuz berdi.');
      }
    } finally {
      if (mounted) _isOpeningFile.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              const SliverDefaultAppBarWg(myTitle: 'Maqola tafsilotlari'),

              /// CATEGORIES tab row
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(right: 20, bottom: 20),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(2, (index) {
                      return EduCategoriesWg(
                        isSelected: selectedCategory == index,
                        onTap: () {
                          setState(() => selectedCategory = index);
                        },
                      );
                    }),
                  ),
                ),
              ),

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

                        final isError = detailState is ReviewDetailError ||
                            authorsState is ReviewAuthorsError;

                        if (isError) {
                          return const SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 48),
                                child: Text(
                                  'Tafsilotlarni yuklashda xatolik yuz berdi',
                                ),
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
                                            : '01.01.2025',
                                        style: AppTextStyles.source.regular(
                                          fontSize: 12,
                                          color: AppColors.greyScale.grey600,
                                        ),
                                      ),
                                      const Spacer(),
                                      ArticlesStatusCheckWg(
                                        status: detail?.articleStatus ??
                                            widget.status,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  /// Body — passes null when loading so skeleton
                                  /// content is naturally shaped like the real data
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
              else ...[
                SliverPadding(
                  padding: const EdgeInsets.only(left: 20, bottom: 20),
                  sliver: SliverToBoxAdapter(
                    child: Text('2-tsikl', style: CustomTextStyles.h2),
                  ),
                ),
                SliverLastActionsWg(items: lastActions),
                SliverPadding(
                  padding: AppPadding.hAndV20x20(),
                  sliver: SliverToBoxAdapter(
                    child: Text('1-tsikl', style: CustomTextStyles.h2),
                  ),
                ),
                SliverLastActionsWg(items: lastActions),
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
      bottomNavigationBar: CustomBottomNavContainerWg(
        leadingIcon: IconlyLight.edit,
        buttonText: 'Tahrirlash',
        onTap: () {},
      ),
    );
  }
}

/// Skeleton placeholder authors — used while bloc is loading so
/// Skeletonizer has shaped content to animate over.
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
