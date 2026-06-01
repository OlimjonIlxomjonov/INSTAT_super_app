import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/custom_linear_indicator/custom_linear_indicator_wg.dart';
import 'package:my_template/core/utils/general_widgets/online_lib_style_custom_bottom_sheet/online_lib_style_custom_bottom_sheet_wg.dart';
import 'package:my_template/core/utils/general_widgets/payment_open_bottom_sheet/payment_open_bottom_sheet_wg.dart';
import 'package:my_template/core/utils/general_widgets/simple_btn_container_wg/simple_btn_container_wg.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/features/scientific_articles_app/dummy_data_source/dummy_data_source_export.dart';
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

  void moveNextPageOrFinish() {
    /// MOVE NEXT PAGE
    if (!isLastPage) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
    // else {
    //   /// OPEN PAYMENT OPTION
    //   onlineLibStyleCustomBottomSheetWg(
    //     context,
    //     headerTitle: 'To\'lov turi',
    //     child: PaymentOpenBottomSheetWg(),
    //   );
    // }
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
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        _showExitDialog(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,

        /// HEADER APP BAR
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(titles[currentPage], style: CustomTextStyles.h2),
        ),

        /// PAGE VIEW BODY
        body: Column(
          crossAxisAlignment: .start,
          children: [
            /// STATIC PAGE DATA
            Padding(
              padding: AppPadding.horizontal20x(),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    '${currentPage + 1}-bosqich: ${stepsDesc[currentPage]}',
                    style: CustomTextStyles.h4,
                  ),
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
              child: CustomLinearIndicatorWg(progressIndicator: progress * 100),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: AppPadding.horizontal20x(),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    articlesHeaderData[currentPage],
                    style: CustomTextStyles.h2,
                  ),
                  Container(
                    padding: const .symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.greyScale.grey50,
                      borderRadius: .circular(6),
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
              onSecondTap: moveNextPageOrFinish,
              onSecondText: !isLastPage ? 'Keyingi qadam' : 'Maqolani yuborish',
            ),
          ],
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
          onPressed: () => Navigator.pop(ctx), // stay
          child: Text("Qolish"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(ctx); // close dialog
            FamilyNavigation.familyClose(context); // close page
          },
          child: Text("Chiqish", style: TextStyle(color: AppColors.red)),
        ),
      ],
    ),
  );
}
