import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/custom_linear_indicator/custom_linear_indicator_wg.dart';
import 'package:my_template/core/utils/general_widgets/online_lib_style_custom_bottom_sheet/online_lib_style_custom_bottom_sheet_wg.dart';
import 'package:my_template/core/utils/general_widgets/payment_open_bottom_sheet/payment_open_bottom_sheet_wg.dart';
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
    } else {
      /// OPEN PAYMENT OPTION
      onlineLibStyleCustomBottomSheetWg(
        context,
        headerTitle: 'To\'lov turi',
        child: PaymentOpenBottomSheetWg(),
      );
    }
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
    return Scaffold(
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
          SizedBox(height: 10),
          Padding(
            padding: AppPadding.horizontal20x(),
            child: CustomLinearIndicatorWg(progressIndicator: progress),
          ),
          SizedBox(height: 20),
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
                  padding: .symmetric(vertical: 5, horizontal: 10),
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
          SizedBox(height: 16),

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
              children: [
                ArticleInfoView(),
                ArticleAddAuthorView(),
                ArticleAnnotationView(),
                ArticlesMainFilesView(),
                ArticleInfoSummerizeView(),
              ],
            ),
          ),

          /// PREV OR NEXT VIEW CONTROLLER
          CustomBottomNavContainerWg(
            buttonText: !isLastPage ? 'Keyingi qadam' : 'Maqolani yuborish',
            onTap: moveNextPageOrFinish,
            anotherButton: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: .circular(12),
                  side: BorderSide(color: AppColors.greyScale.grey200),
                ),
                backgroundColor: AppColors.greyScale.grey50,
                foregroundColor: AppColors.greyScale.grey600,
              ),
              onPressed: () {
                FamilyNavigation.familyClose(context);
              },
              child: Text('Bekor qilish'),
            ),
          ),
        ],
      ),
    );
  }
}
