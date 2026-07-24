import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/confirm_dialog/confirm_dialog_wg.dart';
import 'package:my_template/core/utils/general_widgets/custom_linear_indicator/custom_linear_indicator_wg.dart';
import 'package:my_template/core/utils/general_widgets/online_lib_style_custom_bottom_sheet/online_lib_style_custom_bottom_sheet_wg.dart';
import 'package:my_template/core/utils/general_widgets/simple_btn_container_wg/simple_btn_container_wg.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/features/scientific_articles_app/dummy_data_source/dummy_data_source_export.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/add_article_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/add_article_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/article_process/article_process_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/review_detail/review_detail_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/screens/add_article/page_view_screens/article_add_author_view.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/screens/add_article/page_view_screens/article_annotation_view.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/screens/add_article/page_view_screens/article_info_summerize_view.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/screens/add_article/page_view_screens/article_info_view.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/screens/add_article/page_view_screens/articles_main_files_view.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/widgets/article_payment_options_wg.dart';

class AddArticlePage extends StatefulWidget {
  /// When set, opens the wizard in edit mode and pre-fills from GET reviews/{id}/.
  final int? editReviewId;

  const AddArticlePage({super.key, this.editReviewId});

  @override
  State<AddArticlePage> createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage> {
  final PageController pageController = PageController();

  int currentPage = 0;
  double progress = 0.2;
  bool isLastPage = false;

  bool get _isEditMode => widget.editReviewId != null;

  void moveNextPageOrFinish(BuildContext context) {
    if (!isLastPage) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitArticle(context);
    }
  }

  void _saveDraft(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    context.read<AddArticleBloc>().add(
      SaveArticleDraftEvent(
        onSuccess: () {
          if (mounted) {
            successFlushBar(
              context,
              _isEditMode
                  ? localization.changesSaved
                  : localization.draftSavedSuccessfully,
            );
          }
        },
        onError: (err) {
          if (mounted) {
            errorFlushBar(context, localization.savingError);
          }
        },
      ),
    );
  }

  void _submitArticle(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final bloc = context.read<AddArticleBloc>();
    // Submitting is a payment action (create-order), not a plain status
    // update — pick a method, same as buying a book/course.
    onlineLibStyleCustomBottomSheetWg(
      context,
      headerTitle: localization.paymentTypeTitle,
      child: BlocProvider.value(
        value: bloc,
        child: ArticlePaymentOptionsWg(
          onSuccess: () {
            // DetailedArticlePage (which this wizard was opened on top of,
            // for edits) reads these same global blocs but has no way of
            // knowing the review just changed — without this it keeps
            // showing draft/edit UI even though the backend already moved
            // it to in_review.
            final reviewId = bloc.state.reviewId;
            if (reviewId != null && reviewId != 0) {
              context.read<ReviewDetailBloc>().add(
                ReviewDetailEvent(reviewId: reviewId),
              );
              context.read<ArticleProcessBloc>().add(
                ArticleProcessEvent(articleId: reviewId),
              );
            }
            if (mounted) {
              showSuccessDialog(
                context,
                title: localization.articleSubmitted,
                description: localization.articleSubmittedDescription,
                onDismiss: () => FamilyNavigation.familyClose(context),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        progress = (pageController.page! + 1) / 5;
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BlocProvider<AddArticleBloc>(
        create: (_) {
          final bloc = sl<AddArticleBloc>();
          if (widget.editReviewId != null) {
            bloc.add(LoadArticleForEditEvent(reviewId: widget.editReviewId!));
          }
          return bloc;
        },
        child: BlocListener<AddArticleBloc, AddArticleState>(
          listenWhen: (prev, curr) =>
              prev.errorMessage != curr.errorMessage &&
              curr.errorMessage != null,
          listener: (context, state) {},
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;
              _showExitDialog(context, isEditMode: _isEditMode);
            },
            child: BlocBuilder<AddArticleBloc, AddArticleState>(
              builder: (context, state) {
                if (_isEditMode && _shouldShowEditLoading(state)) {
                  return Scaffold(
                    resizeToAvoidBottomInset: false,
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      centerTitle: true,
                      title: Text(
                        localization.editArticleTitle,
                        style: CustomTextStyles.h2,
                      ),
                    ),
                    body: const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  );
                }

                if (_isEditMode && state.initialLoadError != null) {
                  return Scaffold(
                    resizeToAvoidBottomInset: false,
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      centerTitle: true,
                      title: Text(
                        localization.editArticleTitle,
                        style: CustomTextStyles.h2,
                      ),
                    ),
                    body: Center(
                      child: Padding(
                        padding: AppPadding.horizontal20x(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.initialLoadError!,
                              textAlign: TextAlign.center,
                              style: CustomTextStyles.h4,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () =>
                                  FamilyNavigation.familyClose(context),
                              child: Text(localization.back),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return _buildWizard(context, state);
              },
            ),
          ),
        ),
      ),
    );
  }

  bool _shouldShowEditLoading(AddArticleState state) {
    return state.isLoadingInitialData ||
        (!state.isEditMode && state.initialLoadError == null);
  }

  Widget _buildWizard(BuildContext context, AddArticleState state) {
    final localization = AppLocalizations.of(context)!;
    final titles = getWizardTitles(localization);
    final stepsDesc = getWizardStepsDesc(localization);
    final articlesHeaderData = getArticlesHeaderData(localization);
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    final formKey = ValueKey(
      'add_article_form_${widget.editReviewId ?? 'new'}',
    );

    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              _isEditMode ? localization.editArticleTitle : titles[currentPage],
              style: CustomTextStyles.h2,
            ),
          ),
          bottomNavigationBar: keyboardVisible
              ? null
              : SimpleBtnContainerWg(
                  onFirstTap: () =>
                      _showExitDialog(context, isEditMode: _isEditMode),
                  onSecondTap: state.isSaving
                      ? null
                      : () => moveNextPageOrFinish(context),
                  onSecondText: !isLastPage
                      ? localization.nextStep
                      : localization.submitArticleButton,
                ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: AppPadding.horizontal20x(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${currentPage + 1}-bosqich: ${stepsDesc[currentPage]}',
                        style: CustomTextStyles.h4,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${currentPage + 1} / ${titles.length}',
                      style: CustomTextStyles.h4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: AppPadding.horizontal20x(),
                child: CustomLinearIndicatorWg(
                  progressIndicator: progress * 100,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: AppPadding.horizontal20x(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      articlesHeaderData[currentPage],
                      style: CustomTextStyles.h2,
                    ),
                    GestureDetector(
                      onTap: state.isSaving ? null : () => _saveDraft(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.greyScale.grey50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              IconlyLight.document,
                              color: AppColors.greyScale.grey600,
                            ),
                            Text(
                              ' ${localization.save}',
                              style: AppTextStyles.source.medium(
                                fontSize: 12,
                                color: AppColors.greyScale.grey600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: PageView(
                  key: formKey,
                  controller: pageController,
                  onPageChanged: (newIndex) {
                    setState(() {
                      currentPage = newIndex;
                      isLastPage = newIndex == 4;
                    });
                  },
                  children: const [
                    ArticleInfoView(),
                    ArticleAddAuthorView(),
                    ArticleAnnotationView(),
                    ArticlesMainFilesView(),
                    ArticleInfoSummerizeView(),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (state.isSaving)
          Container(
            color: Colors.black.withValues(alpha: 0.4),
            child: Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 28,
                    horizontal: 36,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator.adaptive(),
                      const SizedBox(height: 16),
                      Text(localization.savingEllipsis),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

void _showExitDialog(BuildContext context, {required bool isEditMode}) {
  final localization = AppLocalizations.of(context)!;
  showConfirmDialog(
    context,
    title: localization.exitConfirmTitle,
    description: isEditMode
        ? localization.exitConfirmEditMode
        : localization.exitConfirmNewMode,
    onConfirm: () => FamilyNavigation.familyClose(context),
  );
}
