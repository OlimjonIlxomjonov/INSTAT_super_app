import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/flush_bar/error_flush_bar.dart';
import 'package:my_template/core/common/flush_bar/success_flush_bar.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/custom_linear_indicator/custom_linear_indicator_wg.dart';
import 'package:my_template/core/utils/general_widgets/simple_btn_container_wg/simple_btn_container_wg.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/features/scientific_articles_app/dummy_data_source/dummy_data_source_export.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/add_article_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/add_article_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/screens/add_article/page_view_screens/article_add_author_view.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/screens/add_article/page_view_screens/article_annotation_view.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/screens/add_article/page_view_screens/article_info_summerize_view.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/screens/add_article/page_view_screens/article_info_view.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/screens/add_article/page_view_screens/articles_main_files_view.dart';

class AddArticlePage extends StatefulWidget {
  const AddArticlePage({super.key});

  @override
  State<AddArticlePage> createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage> {
  final PageController pageController = PageController();
  int currentPage = 0;
  double progress = 0.2;
  bool isLastPage = false;

  void moveNextPageOrFinish(BuildContext context) {
    if (!isLastPage) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Final submit — status = 'pending' means submitted for review
      _submitArticle(context);
    }
  }

  void _saveDraft(BuildContext context) {
    context.read<AddArticleBloc>().add(
      SaveArticleDraftEvent(
        status: 'draft',
        onSuccess: () {
          if (mounted) {
            successFlushBar(context, 'Qoralama muvaffaqiyatli saqlandi!');
          }
        },
        onError: (err) {
          if (mounted) {
            errorFlushBar(context, 'Hech nima kiritilmagan!');
          }
        },
      ),
    );
  }

  void _submitArticle(BuildContext context) {
    context.read<AddArticleBloc>().add(
      SaveArticleDraftEvent(
        status: 'pending',
        onSuccess: () {
          if (mounted) {
            // Show success dialog and close the page
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => AlertDialog.adaptive(
                title: Text('Maqola yuborildi!', style: CustomTextStyles.h2),
                content: Text(
                  'Maqolangiz ko\'rib chiqish uchun qabul qilindi.',
                  style: CustomTextStyles.h4,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      FamilyNavigation.familyClose(context);
                    },
                    child: const Text('Yaxshi'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        progress = (pageController.page! + 1) / titles.length;
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
    return BlocProvider<AddArticleBloc>(
      create: (_) => sl<AddArticleBloc>(),
      child: BlocListener<AddArticleBloc, AddArticleState>(
        listenWhen: (prev, curr) =>
            prev.errorMessage != curr.errorMessage && curr.errorMessage != null,
        listener: (context, state) {
          // Show any unhandled errors from bloc
        },
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            _showExitDialog(context);
          },
          child: BlocBuilder<AddArticleBloc, AddArticleState>(
            buildWhen: (prev, curr) => prev.isSaving != curr.isSaving,
            builder: (context, state) {
              return Stack(
                children: [
                  Scaffold(
                    resizeToAvoidBottomInset: false,

                    /// HEADER APP BAR
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      centerTitle: true,
                      title: Text(
                        titles[currentPage],
                        style: CustomTextStyles.h2,
                      ),
                    ),

                    /// PAGE VIEW BODY
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// STATIC PAGE DATA
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

                              /// SAQLASH (SAVE DRAFT) BUTTON
                              GestureDetector(
                                onTap: state.isSaving
                                    ? null
                                    : () => _saveDraft(context),
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
                                        ' Saqlash',
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

                        /// DYNAMIC PAGES
                        Expanded(
                          child: PageView(
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

                        /// PREV OR NEXT VIEW CONTROLLER
                        SimpleBtnContainerWg(
                          onFirstTap: () => _showExitDialog(context),
                          onSecondTap: state.isSaving
                              ? null
                              : () => moveNextPageOrFinish(context),
                          onSecondText: !isLastPage
                              ? 'Keyingi qadam'
                              : 'Maqolani yuborish',
                        ),
                      ],
                    ),
                  ),

                  /// SAVING OVERLAY
                  if (state.isSaving)
                    Container(
                      color: Colors.black.withValues(alpha: 0.4),
                      child: const Center(
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 28,
                              horizontal: 36,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator.adaptive(),
                                SizedBox(height: 16),
                                Text('Saqlanmoqda...'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

void _showExitDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog.adaptive(
      title: Text("Chiqishni xohlaysizmi?", style: CustomTextStyles.h2),
      content: Text(
        "Kiritilgan ma'lumotlar saqlanmaydi.",
        style: CustomTextStyles.h4,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text("Qolish"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(ctx);
            FamilyNavigation.familyClose(context);
          },
          child: Text("Chiqish", style: TextStyle(color: AppColors.red)),
        ),
      ],
    ),
  );
}
